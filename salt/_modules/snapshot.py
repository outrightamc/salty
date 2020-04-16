def compare(stamp1, stamp2):
    path = 'salt://snapshots/{}_{}.conf'
    diff = __salt__['iosconfig.diff_text'](
        candidate_path=path.format(__opts__['id'], stamp1),
        running_path=path.format(__opts__['id'], stamp2))
    return diff
