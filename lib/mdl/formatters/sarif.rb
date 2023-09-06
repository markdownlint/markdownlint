require 'json'

module MarkdownLint
  # SARIF formatter
  #
  # @see https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html
  class SarifFormatter
    class << self
      def generate(rules, results)
        matched_rules_id = results.map { |result| result['rule'] }.uniq
        matched_rules = rules.select { |id, _| matched_rules_id.include?(id) }
        JSON.generate(generate_sarif(matched_rules, results))
      end

      def generate_sarif(rules, results)
        {
          :'$schema' => 'https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json',
          :version => '2.1.0',
          :runs => [
            {
              :tool => {
                :driver => {
                  :name => 'Markdown lint',
                  :version => MarkdownLint::VERSION,
                  :informationUri => 'https://github.com/markdownlint/markdownlint',
                  :rules => generate_sarif_rules(rules),
                },
              },
              :results => generate_sarif_results(rules, results),
            }
          ],
        }
      end

      def generate_sarif_rules(rules)
        rules.map do |id, rule|
          {
            :id => id,
            :name => rule.aliases.first.split('-').map(&:capitalize).join,
            :defaultConfiguration => {
              :level => 'note',
            },
            :properties => {
              :description => rule.description,
              :tags => rule.tags,
              :queryURI => rule.docs_url,
            },
            :shortDescription => {
              :text => rule.description,
            },
            :fullDescription => {
              :text => rule.description,
            },
            :helpUri => rule.docs_url,
            :help => {
              :text => "More info: #{rule.docs_url}",
              :markdown => "[More info](#{rule.docs_url})",
            },
          }
        end
      end

      def generate_sarif_results(rules, results)
        results.map do |result|
          {
            :ruleId => result['rule'],
            :ruleIndex => rules.find_index { |id, _| id == result['rule'] },
            :message => {
              :text => "#{result['rule']} - #{result['description']}",
            },
            :locations => [
              {
                :physicalLocation => {
                  :artifactLocation => {
                    :uri => result['filename'],
                    :uriBaseId => '%SRCROOT%',
                  },
                  :region => {
                    :startLine => result['line'],
                  },
                },
              }
            ],
          }
        end
      end
    end
  end
end
