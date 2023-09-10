local CollectionView = require('cylibs/ui/collection_view/collection_view')
local CollectionViewDataSource = require('cylibs/ui/collection_view/collection_view_data_source')
local IndexPath = require('cylibs/ui/collection_view/index_path')
local Padding = require('cylibs/ui/style/padding')
local TextCollectionViewCell = require('cylibs/ui/collection_view/cells/text_collection_view_cell')
local TextItem = require('cylibs/ui/collection_view/items/text_item')
local TextStyle = require('cylibs/ui/style/text_style')
local VerticalFlowLayout = require('cylibs/ui/collection_view/layouts/vertical_flow_layout')

local HelpView = setmetatable({}, {__index = CollectionView })
HelpView.__index = HelpView

function HelpView.new(main_job_name_short)
    local dataSource = CollectionViewDataSource.new(function(item)
        local cell = TextCollectionViewCell.new(item)
        cell:setItemSize(20)
        cell:setUserInteractionEnabled(true)
        return cell
    end)

    local self = setmetatable(CollectionView.new(dataSource, VerticalFlowLayout.new(2, Padding.new(10, 15, 0, 0))), HelpView)

    dataSource:addItem(TextItem.new("Wiki", TextStyle.Default.Text), IndexPath.new(1, 1))
    dataSource:addItem(TextItem.new("• "..main_job_name_short, TextStyle.Default.Text), IndexPath.new(1, 2))
    dataSource:addItem(TextItem.new("• Commands", TextStyle.Default.Text), IndexPath.new(1, 3))
    dataSource:addItem(TextItem.new("• Shortcuts", TextStyle.Default.Text), IndexPath.new(1, 4))
    dataSource:addItem(TextItem.new("", TextStyle.Default.Text), IndexPath.new(1, 5))

    dataSource:addItem(TextItem.new("Discord", TextStyle.Default.Text), IndexPath.new(2, 1))
    dataSource:addItem(TextItem.new("• Join the Discord", TextStyle.Default.Text), IndexPath.new(2, 2))

    self:getDisposeBag():add(self:getDelegate():didSelectItemAtIndexPath():addAction(function(item, indexPath)
        local row = indexPath.row
        if indexPath.section == 1 then
            if row == 2 then
                local urlSuffix = self:getJobWikiPageSuffix(main_job_name_short)
                self:openUrl(urlSuffix)
            elseif row == 3 then
                self:openUrl('Commands')
            elseif row == 4 then
                self:openUrl('Shortcuts')
            end
        elseif indexPath.section == 2 then
            if row == 2 then
                self:openUrl('#support')
            end
        end
    end), self:getDelegate():didSelectItemAtIndexPath())

    return self
end

function HelpView:openUrl(url_suffix)
    windower.open_url(settings.help.wiki_base_url..'/'..url_suffix)
end

function HelpView:getJobWikiPageSuffix(job_name_short)
    local job = res.jobs:with('ens', job_name_short)
    if job then
        local url_suffix = job.name:gsub(" ", "-")
        return url_suffix
    end
    return 'Trusts'
end

return HelpView