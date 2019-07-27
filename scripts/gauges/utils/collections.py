

class BaseCollection:

    # 必须是唯一限定的字段
    KEYS = ['id']

    def __init__(self, rows=None):
        for key in self.KEYS:
            self._get_cache(key)
        self.append([] if rows is None else rows)

    def _get_cache(self, key):
        """ 以特定字段作为缓存 """
        attr = '_' + key + 's'
        if not hasattr(self, attr):
            setattr(self, attr, {})
        return getattr(self, attr)

    def _clean(self, key, value):
        """ 允许对值进行变换
        比如：前缀依赖设置，可以去掉可变部分
        """
        meth_name = 'clean_' + key
        if hasattr(self, meth_name):
            return getattr(self, meth_name)(value)
        return value

    def append(self, results):
        """ 分别按字段进行缓存 """
        for key in self.KEYS:
            cache = self._get_cache(key)
            for row in results:
                cache_key = row[key]
                cache_key = self._clean(key, cache_key)
                cache[cache_key] = row

    def fetch(self, **kwargs):
        """ 只允许检索缓存字段 """
        prev = None
        for key, cache_key in kwargs.items():
            cache = self._get_cache(key)
            cache_key = self._clean(key, cache_key)
            curr = cache.get(cache_key)
            # 任意一项不符则立即返回
            if curr is None:
                return None
            # 多项都有结果但各不相同，也理解返回
            if prev is not None and curr != prev:
                return None
            prev = curr
        return prev

    def search(self, **kwargs):
        """ 允许检索所以字段 """
        results = []
        if not kwargs:
            return results
        expect = {
            key: self._clean(key, given)
            for key, given in kwargs.items()
        }
        for _, row in self._ids.items():
            for key in kwargs:
                # 任一项不符合则跳过
                if self._clean(key, row[key]) != expect[key]:
                    break
            else:
                # 所有项都符合(没触发break)才加入结果集
                results.append(row)
        return results

    def any(self):
        """ 任意一条有效记录 """
        for _, row in self._ids.items():
            return row
        return None


class UserCollection(BaseCollection):

    KEYS = ['id', 'username']
