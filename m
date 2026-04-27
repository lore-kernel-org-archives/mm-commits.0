Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF943B9DAD
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294512; cv=none; b=twq+o0th7w/HHjR8MvNqPAZTWIuBxuzKDqWw6OEHgaCuxAwoNIzU+je1o8YYzNQWcxHu5nRpZjMBMaqmf5RWaBZpAMZir6zbzZ8vqXJu5L1TBKyiGKXds20B4kgmzpE6xjg/J9GgBQ5bbuo5HxiZW1zOhGtZ/fstra+u7NleX94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294512; c=relaxed/simple;
	bh=cNNe1zI8ZyscZiD+yNZxfCcpYRd8XrfDA7Skk2FFHgw=;
	h=Date:To:From:Subject:Message-Id; b=O/k0Evh1GQmsXMH/RjCg/7ggKgJviuTbB1Mn/NgFghHfjtoDJ1lRB7pPlYcpID9uqiqwbTUAqx3bmNnUmmBSKopLTH3U3VtnrdKzX9iHSyHCMb/Hwx323rJa1aKu7hHQtUsvvXGOmwNgJJZ8uvQwRt06KIyQzUfQt+j8nDjeii4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1XEpD85+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1XEpD85+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49290C19425;
	Mon, 27 Apr 2026 12:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294512;
	bh=cNNe1zI8ZyscZiD+yNZxfCcpYRd8XrfDA7Skk2FFHgw=;
	h=Date:To:From:Subject:From;
	b=1XEpD85++QDAelEI3tgfjcjxjBAX9WrTAYJreaXifdxQiqigHFJknYPaj5z1+AuGR
	 nt3cSJSyR5n2K4dC912ClW4OCkoW7pamSIZX4nJNJ+67GiZilIUmHMMGTabBTpqdvC
	 x/IfObNJSypBzzTPc5qyoVmZhqqgTeCLYfc/7fJs=
Date: Mon, 27 Apr 2026 05:55:11 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-mailmap-update-email-address-for-qi-zheng.patch removed from -mm tree
Message-Id: <20260427125512.49290C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS, mailmap: update email address for Qi Zheng
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-email-address-for-qi-zheng.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: MAINTAINERS, mailmap: update email address for Qi Zheng
Date: Thu, 23 Apr 2026 15:16:28 +0800

Update my email address to qi.zheng@linux.dev.

Link: https://lore.kernel.org/20260423071628.44044-1-qi.zheng@linux.dev
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/.mailmap~maintainers-mailmap-update-email-address-for-qi-zheng
+++ a/.mailmap
@@ -689,6 +689,7 @@ Punit Agrawal <punitagrawal@gmail.com> <
 Puranjay Mohan <puranjay@kernel.org> <puranjay12@gmail.com>
 Qais Yousef <qyousef@layalina.io> <qais.yousef@imgtec.com>
 Qais Yousef <qyousef@layalina.io> <qais.yousef@arm.com>
+Qi Zheng <qi.zheng@linux.dev> <zhengqi.arch@bytedance.com>
 Quentin Monnet <qmo@kernel.org> <quentin.monnet@netronome.com>
 Quentin Monnet <qmo@kernel.org> <quentin@isovalent.com>
 Quentin Perret <qperret@qperret.net> <quentin.perret@arm.com>
--- a/MAINTAINERS~maintainers-mailmap-update-email-address-for-qi-zheng
+++ a/MAINTAINERS
@@ -16984,7 +16984,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	Johannes Weiner <hannes@cmpxchg.org>
 R:	David Hildenbrand <david@kernel.org>
 R:	Michal Hocko <mhocko@kernel.org>
-R:	Qi Zheng <zhengqi.arch@bytedance.com>
+R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
@@ -24315,7 +24315,7 @@ F:	include/media/i2c/rj54n1cb0c.h
 SHRINKER
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Dave Chinner <david@fromorbit.com>
-R:	Qi Zheng <zhengqi.arch@bytedance.com>
+R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Roman Gushchin <roman.gushchin@linux.dev>
 R:	Muchun Song <muchun.song@linux.dev>
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


