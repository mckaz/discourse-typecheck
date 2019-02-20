require_relative '../db-types/active-record/db_types.rb'
#require_relative '../db_type_check/ar_types.rb'

## the file required below builds a model of the DB schema used during type checking.
require './build_schema.rb'


puts "Type checking Discourse methods..."


## Type annotations for type checked methods are below.

RDL.type User, 'self.new_from_params', '({ name: String, email: String, password: String, username: String }) -> User', typecheck: :later, wrap: false
RDL.type User, 'self.find_by_username', '(String) -> User', typecheck: :later, wrap: false
RDL.type User, 'self.username_available?', "(String, ?String) -> %bool", typecheck: :later, wrap: false
RDL.type User, :featured_user_badges, '(?Integer) -> %any', typecheck: :later, wrap: false
RDL.type User, :email_confirmed?, '() -> %bool', typecheck: :later, wrap: false
RDL.type EmailToken, 'self.active', '() -> ActiveRecord_Relation<EmailToken>', wrap: false, typecheck: :later
RDL.type User, :activate, '() -> %bool or nil', typecheck: :later, wrap: false
RDL.type User, :number_of_deleted_posts, '() -> Integer', typecheck: :later, wrap: false
RDL.type User, :number_of_flags_given, '() -> Integer', typecheck: :later, wrap: false
RDL.type User, :create_user_profile, '() -> UserProfile', typecheck: :later, wrap: false
RDL.type User, :create_user_option, '() -> UserOption', typecheck: :later, wrap: false
RDL.type User, :create_email_token, '() -> EmailToken', typecheck: :later, wrap: false
RDL.type User, :update_username_lower, '() -> String', typecheck: :later, wrap: false
RDL.type User, :seen_before?, '() -> %bool', typecheck: :later, wrap: false
RDL.type Post, :seen?, '(User) -> %bool', typecheck: :later, wrap: false
RDL.type Post, 'self.find_by_detail', '(String, String) -> Post', typecheck: :later, wrap: false
RDL.type Post, :has_active_flag?, '() -> %bool', typecheck: :later, wrap: false
RDL.type Post, :is_flagged?, '() -> %bool', typecheck: :later, wrap: false
RDL.type Post, :is_reply_by_email?, '() -> %bool', typecheck: :later, wrap: false
RDL.type Post, :add_detail, "(String, String, ?String) -> PostDetail", typecheck: :later, wrap: false
RDL.type Post, :limit_posts_per_day, '() -> RateLimiter', typecheck: :later, wrap: false
RDL.type Archetype, 'self.private_message', '() -> String', typecheck: :later, wrap: false
RDL.type Group, :posts_for, '(Guardian, ?Hash<Symbol, Integer>) -> ActiveRecord_Relation<JoinTable<Post, User or Topic or Category>>', typecheck: :later, wrap: false
RDL.type Group, :messages_for, '(Guardian, ?Hash<Symbol, Integer>) -> ActiveRecord_Relation<JoinTable<Post, User or Topic or Category>>', typecheck: :later, wrap: false
RDL.type Group, :mentioned_posts_for, '(Guardian, ?Hash<Symbol, Integer>) -> ActiveRecord_Relation<JoinTable<Post, User or Topic or Category or GroupMention>>', typecheck: :later, wrap: false
RDL.type Group, 'self.trust_group_ids', '() -> Array<Integer>', typecheck: :later, wrap: false
RDL.type Group, 'self.desired_trust_level_groups', '(Integer) -> Array<Integer>', typecheck: :later, wrap: false
RDL.type Group, 'self.user_trust_level_change!', '(Integer, Integer) -> Array<Integer>', typecheck: :later, wrap: false
RDL.type Group, 'self.refresh_automatic_group!', '(Symbol) -> Group', typecheck: :later, wrap: false
RDL.type Group, 'self.lookup_group', "(Symbol) -> Group", typecheck: :later, wrap: false
RDL.type Draft, 'self.find_draft', '(User or Integer, String) -> Draft', typecheck: :later, wrap: false
RDL.type Topic, :update_action_counts, '() -> %bool', typecheck: :later, wrap: false
RDL.type Topic, :has_topic_embed?, '() -> %bool', typecheck: :later, wrap: false
RDL.type Topic, :expandable_first_post?, '() -> %bool', typecheck: :later, wrap: false
RDL.type Notification, 'self.remove_for', '(Integer, Integer) -> Integer', typecheck: :later, wrap: false
RDL.type Notification, :post, '() -> Post', typecheck: :later, wrap: false


## Type annotations for variables and unchecked methods are below. The methods are from the Discourse app, or from external libraries.
RDL.type Badge, 'self.trust_level_badge_ids', '() -> [1,2,3,4]', wrap: false
RDL.type User, :email, '() -> String', wrap: false
RDL.type User, :email=, '(String) -> String', wrap: false
RDL.type User, :password=, '(String) -> String', wrap: false
RDL.type User, 'self.reserved_username?', "(String) -> %bool", wrap: false
RDL.type EmailToken, 'self.valid_after', '() -> Hash', wrap: false
RDL.type EmailToken, 'self.confirm', '(String) -> %bool', wrap: false
RDL.type ActiveRecord::Base, 'self.with_deleted', '() -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), DBType.rec_to_nominal(trec))``', wrap: false
RDL.type PostActionType, 'self.notify_flag_type_ids', '() -> Array<Integer>', wrap: false
RDL.type PostActionType, 'self.flag_types_without_custom', '() -> Hash<Symbol, Integer>', wrap: false
RDL.var_type User, :@raw_password, "String"
RDL.var_type User, :@password_required, "%bool"
RDL.type User, :new_user_posting_on_first_day?, '() -> %bool', wrap: false
RDL.type SiteSetting, 'self.max_replies_in_first_day', '() -> Integer'
RDL.type RateLimiter, :initialize, '(User, String, Integer, Integer, ?{global: %bool}) -> self', wrap: false
RDL.type Post, 'self.types', '() -> Hash<Symbol, Integer>', wrap: false
RDL.type I18n, 'self.t', '(String) -> String', wrap: false
RDL.type UsernameValidator, :initialize, '(String) -> self', wrap: false
RDL.type UsernameValidator, :valid_format?, '() -> %bool', wrap: false
RDL.type Group, 'self.visibility_levels', '() -> Hash<Symbol, Integer>', wrap: false
RDL.type Theme, :included_themes, '() -> Array<Theme>', wrap: false
RDL.type SiteSetting, 'self.embed_truncate?', '() -> %bool', wrap: false
RDL.type MiniSqlMultisiteConnection, 'exec', "(String) -> %any", wrap: false
RDL.type ActiveRecord::AttributeMethods::ClassMethods, 'attribute_names', '() -> Array<String>', wrap: :false
RDL.type ActiveRecord_Relation, :attribute_names, '() -> Array<String>', wrap: false
RDL.type ActiveRecord_Relation, :active, '() -> self', wrap: false
RDL.type Object, :blank?, '() -> %bool', wrap: false
RDL.type Integer, :day, '() -> ActiveSupport::Duration', wrap: false
RDL.type ActiveSupport::Duration, :to_i, '() -> Integer', wrap: false
RDL.type TopicGuardian, :filter_allowed_categories, '(t) -> t', wrap: false
RDL.type ActiveRecord::Base, 'self.exec_sql', '(String) -> %bool', wrap: false
RDL.type ActiveRecord::Base, 'self.reset_counters', '(Integer, Symbol) -> Integer', wrap: false



## Call `do_typecheck` to type check methods with :later tag
## The second argument is optional and is used for printing configurations.
RDL.do_typecheck :later, (ENV["NODYNCHECK"] || ENV["TYPECHECK"])



