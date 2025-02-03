module RansackPatch
    def ransackable_attributes(auth_object = nil)
      authorizable_ransackable_attributes
    end
  
    def ransackable_associations(auth_object = nil)
      authorizable_ransackable_associations
    end
  end
  
  ActiveSupport.on_load(:active_record) do
    extend RansackPatch
  end