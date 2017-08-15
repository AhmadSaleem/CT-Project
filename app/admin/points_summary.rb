ActiveAdmin.register PointsSummary, as: 'Point Summary' do
  permit_params :points, :scoring_area, :format
end

