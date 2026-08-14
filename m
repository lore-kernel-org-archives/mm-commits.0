Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFCB1F1534
	for <mm-commits@vger.kernel.org>; Fri, 14 Aug 2026 01:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786669716; cv=none; b=LEzzqwkcdHL48vvrGAAWFiEpZPu49I6jXEmZASypmyXTqw2XoxSKh94qIi6UJDfsDL12GcTVzJkuBdXFbw6aJJnKHdrPtPHpTDAQWLkRHlmTx1wGr67YtDZNd8oZgR8k9u5oeNe2ZsuD4i7jXBUE9ANg1gQFXgWQh2Lbr/AB1a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786669716; c=relaxed/simple;
	bh=XRqnrXc+y6ZQq1fB84UQxtXTkw2zmTMSwF77n7S+v1M=;
	h=Date:To:From:Subject:Message-Id; b=Mkkl9Zv4ukPv882KLrKwmOp/E3kvbLnX+0sPDj1fD0pQVF58LwgEH14boxo6oztGptiCJEfPqlD8LgON/Rc9PEB1kvDt7X/ZW+41u14WdC7P/9iHLB9o9OJUrJtAl+EXdwKFAmq9f6xylcfKAtWbGWAqukKjivGKLOB+cVCaRJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=milHy45y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="milHy45y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374D71F00A3A;
	Fri, 14 Aug 2026 01:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786669715;
	bh=iktxQMK423xt+h1JjhspuqWyJkqTKXvpjWEGfLQk1Uc=;
	h=Date:To:From:Subject;
	b=milHy45y3l/ignJpmgSen2YzDZWnWDDKNkc525HDtsE0p+iTkmQbzc5iSRIQ/tigo
	 UQ45ULF6M+1/NWoH9CQWDocn4US5RMyTTJ9z1dgc4+14KtFofbe6zpyJsP9WwwKKwG
	 UshLdRfQPufZSHjXU+rLHpdG9x6hJbikHqSQI9b4=
Date: Thu, 13 Aug 2026 18:08:34 -0700
To: mm-commits@vger.kernel.org,debarbos@redhat.com,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-remove-git-url-for-squashfs.patch removed from -mm tree
Message-Id: <20260814010835.374D71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: remove git URL for Squashfs
has been removed from the -mm tree.  Its filename was
     maintainers-remove-git-url-for-squashfs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: MAINTAINERS: remove git URL for Squashfs
Date: Thu, 6 Aug 2026 19:19:15 +0100

The squashfs-next.git URL hasn't been updated for many years, and it now
doesn't exist.

So remove it from the MAINTAINERS entry.

Link: https://lore.kernel.org/20260806181916.617881-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Derek Barbosa <debarbos@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-git-url-for-squashfs
+++ a/MAINTAINERS
@@ -25553,7 +25553,6 @@ M:	Phillip Lougher <phillip@squashfs.org
 L:	squashfs-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 W:	http://squashfs.org.uk
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next.git
 F:	Documentation/filesystems/squashfs.rst
 F:	fs/squashfs/
 
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


