class NestedParamsFormBuilder < ActionView::Helpers::FormBuilder
  def fields_for(record_or_name_or_array, *args, &block)
    if record_or_name_or_array.is_a?(String) || record_or_name_or_array.is_a?(Symbol)
      # Is this reflecting bad speed wise? And is there an alternative?
      if reflection = @object.class.reflect_on_all_associations.detect { |r| r.name == record_or_name_or_array.to_sym }
        if reflection.macro == :has_many
          record = args.first
          # In the case of a new object use a fictive id which is composited with "new_" and the @child_counter.
          name = "#{object_name}[#{record_or_name_or_array}_attributes][#{ record.new_record? ? "new_#{child_counter}" : record.id}]"
          return @template.fields_for(name, *args, &block)
        end
      end
    end
    super
  end
  
  private
  
  def child_counter
    @child_counter ||= 1
    value = @child_counter
    @child_counter += 1
    value
  end
end