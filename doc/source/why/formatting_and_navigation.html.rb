require 'source/why/example_page'

module Views
  module Why
    class FormattingAndNavigation < Views::Why::ExamplePage
      def example_content
        erb_example
        fortitude_output
        about_production
        transition
        # the_html
      end

      def erb_example
        h4 "Output from ERb"

        p {
          text "In even moderately-sized systems, we're often faced with this challenge: we want to change some "
          text "of the HTML generated by the application — but, first, we need to figure out what view, partial, or "
          text "helper generates that HTML."
        }

        p {
          text "As an example, imagine we want to change part of the HTML displayed below. This is real output from "
          text "a pretty well-factored set of ERb views and partials, taken from a real, commercial application "
          text "(albeit with the classes and model names changed)."
        }

        html_source <<-EOS
  <div class="input boolean optional field_with_hint"><input name="user_preferences[visible_to_public]" type="hidden" value="0" /><label class="boolean optional control-label checkbox" for="user_preferences_visible_to_public"><input class="boolean optional" id="user_preferences_visible_to_public" name="user_preferences[visible_to_public]" type="checkbox" value="1" />Visible to Public</label><span class="hint">Enable visibility to public</span><div class="input_error"><span class="tooltip"></span></div></div>
  <div class="input boolean optional field_with_hint"><input name="user_preferences[email_over_sms]" type="hidden" value="0" /><label class="boolean optional control-label checkbox" for="user_preferences_email_over_sms"><input class="boolean optional" id="user_preferences_email_over_sms" name="user_preferences[email_over_sms]" type="checkbox" value="1" />Prefer email to SMS for communication</label><span class="hint">Prefer sending email to sending SMSes</span><div class="input_error"><span class="tooltip"></span></div></div>
  <div class="input string optional field_with_hint"><label class="string optional control-label" for="user_preferences_name_override">Show this name to public instead</label><input class="string optional" id="user_preferences_name_override" name="user_preferences[name_override]" size="50" style="width: 1070px" type="text" value="" /><span class="hint">Specify custom name to be shown instead of user's actual name</span><div class="input_error"><span class="tooltip"></span></div></div>

  <input name="commit" type="submit" value="Update User Preferences" />
</form>

<h4>Custom Blocking Rules</h4>
<table class="readable">
  <thead>
    <tr>
      <th>type</th>
      <th>pattern</th>
      <th>rules</th>
      <th>actions</th>
    </tr>
  </thead>
  <tbody>
  </tbody>
</table>
<a href="/admin/users/4832424/blocking_rules/new">create blocking patterns</a>

<h4>Friend Relationship Analysis</h4>

<a href="/admin/relationships/4832424">View Relationship Analysis</a><br />
<a href="/admin/relationships/4832424.csv">View Relationship Analysis as CSV</a>

<h4>Whitelisted Applications</h4>
EOS

        p {
          text "Looking at that HTML:"
        }

        ul {
          li "Can you read it?"
          li "How would you tell which partial or view generates a given bit of HTML?"
        }

        p {
          text "It ain’t pretty. This usually boils down to either guessing at views/partials until you stumble on the "
          text "right one, or looking for uncommon strings in the code (CSS class names are usually a good one) and "
          text "doing large-scale searches in your "; code "app/views"; text " tree to see where they show up."
        }

        p {
          text "Neither of these seem like things we should regularly be doing in 2015."
        }


        # the_html
      end

      def fortitude_output
        h4 "Output from Fortitude"

        p {
          text "If we translate the code into Fortitude, let's look at what we get instead. (We’ve made zero effort "
          text "to “clean up” or otherwise refactor the Fortitude code.)"
        }

        html_source <<-EOS
      <!-- BEGIN Views::Admin::Users::BooleanUserPreference depth 2: :name => "visible_to_public", :display => "Visible to Public", :hint => "Enable visiblity to public" -->
      <div class="input boolean optional field_with_hint">
        <input name="user_preferences[visible_to_public]" type="hidden" value="0">
        <label class="boolean optional control-label checkbox" for="user_preferences_visible_to_public">
          <input class="boolean optional" id="user_preferences_visible_to_public" name="user_preferences_visible_to_public" type="checkbox" value="1">
          Visible to Public
        </label>
        <span class="hint">Enable visiblity to public</span>
        <div class="input_error">
          <span class="tooltip"></span>
        </div>
      </div>
      <!-- END Views::Admin::Users::BooleanUserPreference depth 2 -->
      <!-- BEGIN Views::Admin::Users::BooleanUserPreference depth 2: :name => "email_over_sms", :display => "Prefer email to SMS for communication", :hint => "Prefer sending email to sending SMSes" -->
      <div class="input boolean optional field_with_hint">
        <input name="user_preferences[email_over_sms]" type="hidden" value="0">
        <label class="boolean optional control-label checkbox" for="user_preferences_email_over_sms">
          <input class="boolean optional" id="user_preferences_email_over_sms" name="user_preferences_email_over_sms" type="checkbox" value="1">
          Prefer email to SMS for communication
        </label>
        <span class="hint">Prefer sending email to sending SMSes</span>
        <div class="input_error">
          <span class="tooltip"></span>
        </div>
      </div>
      <!-- END Views::Admin::Users::BooleanUserPreference depth 2 -->
      <!-- BEGIN Views::Admin::Users::StringUserPreference depth 2: :name => "name_override", :display => "Show this name to public instead", :hint => "Specify custom name to be shown instead of user's actual name" -->
      <div class="input string optional field_with_hint">
        <label class="string optional control-label" for="user_preferences_name_override">
          Show this name to public instead
        </label>
        <input class="string optional" id="user_preferences_name_override" name="user_preferences_name_override" size="50" style="width: 1070px" type="text" value="">
        <span class="hint">Specify custom name to be shown instead of user&#39;s actual name</span>
        <div class="input_error">
          <span class="tooltip"></span>
        </div>
      </div>
      <!-- END Views::Admin::Users::StringUserPreference depth 2 -->
      <!-- END Views::Admin::Users::PreferencesList depth 1 -->
      <!-- BEGIN Views::Admin::Users::CustomBlockingRules depth 1 -->
      <h4>Custom Blocking Rules</h4>
      <table class="readable">
        <thead>
          <tr>
            <th>type</th>
            <th>pattern</th>
            <th>rules</th>
            <th>actions</th>
          </tr>
        </thead>
        <tbody></tbody>
      </table>
      <a href="/admin/users/4832424/blocking_rules/new">create blocking patterns</a>
      <!-- END Views::Admin::Users::CustomBlockingRules depth 1 -->
      <!-- BEGIN Views::Admin::Users::RelationshipAnalysis depth 1 -->
      <h4>Friend Relationship Analysis</h4>
      <a href="/admin/relationships/4832424">View Relationship Analysis</a>
      <br>
      <a href="/admin/relationships/4832424.csv">View Relationship Analysis as CSV</a>
      <!-- END Views::Admin::Users::RelationshipAnalysis depth 1 -->
      <!-- BEGIN Views::Admin::Users::WhitelistedApplications depth 1 -->
      <h4>Whitelisted Applications</h4>
EOS

        p {
          text "What’s happened here?"
        }

        ul {
          li {
            strong "Formatting"; text ": All of our HTML is perfectly indented according to the actual structure of "
            text "the DOM…and, unlike many templating engines, this even works perfectly across partials. (Your entire "
            text "page will be indented properly, all the way down, no matter what the structure of your views or "
            text "partials is.) This alone makes the output vastly more readable."
          }
          li {
            p {
              strong "Comments"; text ": Fortitude automatically adds comments to the generated HTML output, every time "
              text "a widget is invoked. These comments tell you exactly what widget class is being rendered, what "
              text "variables it was passed, and how deeply down the stack of views/partials it’s been nested "
              text "(which can be completely different from the nesting/indentation depth of the DOM/HTML structure itself). "
            }
            p {
              text "At this point, it’s trivial to see "
              text "exactly what view or partial contains the source code for any given section of HTML output."
            }
          }
        }

        p {
          text "Just through these two small features alone, Fortitude makes it a great deal easier to figure out "
          text "what’s going on in your rendered HTML and trace it back to the source code."
        }
      end

      def about_production
        h4 "But What About Production?"

        p {
          text "In production, by default, both these features are switched off. The lack of comments means you won’t "
          text "expose the internal structure of your source code, and the lack of formatting means that you’ll actually "
          text "get "; strong "better"; text " HTML output in production with Fortitude than with ERb. In production, "
          text "Fortitude emits tags with no whitespace between them, causing the server to transmit as few bytes as "
          text "possible to the client for a given section of rendered HTML."
        }
      end

      def transition
        p {
          text "In our next example, we’ll look at the last of Fortitude’s major features: its runtime performance. "
          text "Given that Fortitude is quite a lot more sophisticated than other templating engines, how much does "
          text "it pay for that advantage in maintainability and factorability?"
        }
      end

      class ::User
        def initialize(id, name)
          @id = id
          @name = name
        end
      end

      def the_html
        require 'source/why/formatting_example/preferences_list'
        require 'source/why/formatting_example/custom_blocking_rules'
        require 'source/why/formatting_example/relationship_analysis'
        require 'source/why/formatting_example/whitelisted_applications'

        user = User.new(4832424, "Megan Yelms")

        widget Views::Admin::Users::PreferencesList, :user => user
        widget Views::Admin::Users::CustomBlockingRules, :user => user
        widget Views::Admin::Users::RelationshipAnalysis, :user => user
        widget Views::Admin::Users::WhitelistedApplications, :user => user
      end
    end
  end
end