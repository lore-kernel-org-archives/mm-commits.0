Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46301DDA1
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hfp4Ycot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C340BC433F1;
	Wed, 10 Jan 2024 05:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704864772;
	bh=lN0iHXoX1VRpi7ybMPY4+hokflJeDAqCGuZyjdtg95Q=;
	h=Date:To:From:Subject:From;
	b=Hfp4YcotCvlvazzeOjFEs33q74oWvTAAcx4PeJtjR5zoDQwKj+KZn5YdSM9FAJh6h
	 AcZKja+YoUYe6la4H6YYyfG6RF+hBzUlIGxEEUZSM5EeefZ/lh56gvR8NFpLDHffPm
	 t6zxpQB/UhZ7wWylCCOcfRYC9mni1xxnJN0VkZ6o=
Date: Tue, 09 Jan 2024 21:32:52 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,zhangyongzhen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-spelling-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240110053252.C340BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: Spelling fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-spelling-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-spelling-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yongzhen Zhang <zhangyongzhen@kylinos.cn>
Subject: ocfs2: Spelling fix
Date: Mon, 8 Jan 2024 09:56:04 +0800

Modify reques to request in the comment.

Link: https://lkml.kernel.org/r/20240108015604.38377-1-zhangyongzhen@kylinos.cn
Signed-off-by: Yongzhen Zhang <zhangyongzhen@kylinos.cn>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-spelling-fix
+++ a/fs/ocfs2/dlmglue.c
@@ -1615,7 +1615,7 @@ update_holders:
 unlock:
 	lockres_clear_flags(lockres, OCFS2_LOCK_UPCONVERT_FINISHING);
 
-	/* ocfs2_unblock_lock reques on seeing OCFS2_LOCK_UPCONVERT_FINISHING */
+	/* ocfs2_unblock_lock request on seeing OCFS2_LOCK_UPCONVERT_FINISHING */
 	kick_dc = (lockres->l_flags & OCFS2_LOCK_BLOCKED);
 
 	spin_unlock_irqrestore(&lockres->l_lock, flags);
_

Patches currently in -mm which might be from zhangyongzhen@kylinos.cn are

ocfs2-spelling-fix.patch

