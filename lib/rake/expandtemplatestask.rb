create_task :expandtemplates, Proc.new { ExpandTemplates.new } do |exp|
  exp.expand
end
