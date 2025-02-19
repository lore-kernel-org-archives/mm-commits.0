Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960CD1CAA65
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 23:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740007114; cv=none; b=Qy7BpBlx1wHk0SQ3QbUpRaiQ+DH6BDvW4A31QRKYTKRb5zh8rCWlkSd2WCZE/nSMDmBTPEW2dPwT6mV2Si77Bj2+cFLNDgBijVsyPxhXsjjf+tGDsKH8QEUGuIEIpmQJSJK/ug4rDxq98nqKD3/KyqVejCcWLXVZUOOOkb+4TC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740007114; c=relaxed/simple;
	bh=aKybTfozdNyzZrU63aWKpL/WEE4ydDnuaROy4Dd60qk=;
	h=Date:To:From:Subject:Message-Id; b=MJx0zSDUbfuwx5C+7gez2E0v7wGUVa0w8gkAOZQ2P8zxF9u5RbzjpPOmN16QW14vziMoT8ogz8WO03aodzHLWgAX0Wq9sKyUaenn4NjoDx+QlpJGixowxebGeGeBYr+PaWbGprthPQ0kTHOopJrXOmvbJOLAK3XoCyTI42ggYWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ieAS7ADJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ieAS7ADJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AA2C4CED1;
	Wed, 19 Feb 2025 23:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740007114;
	bh=aKybTfozdNyzZrU63aWKpL/WEE4ydDnuaROy4Dd60qk=;
	h=Date:To:From:Subject:From;
	b=ieAS7ADJe65sgpjpn7fgESUKaJzuwRyqHIGpO+86altPwwih/4JEzS6UyIOPy703B
	 dEVkNLfQK5z+EBg9b4GzWZ/6AbwaJ10BL68tt1V2ktcmaSdulY9Szl66X3jlWkkCqH
	 npioH75c9pVVnSUDUB+CBLJFYsXDc0utC90g2Qfg=
Date: Wed, 19 Feb 2025 15:18:33 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,dev.jain@arm.com,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-update-hyeonggons-name-and-email-address.patch added to mm-nonmm-unstable branch
Message-Id: <20250219231834.06AA2C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: mailmap: update Hyeonggon's name and email address
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-mailmap-update-hyeonggons-name-and-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-update-hyeonggons-name-and-email-address.patch

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
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: MAINTAINERS: mailmap: update Hyeonggon's name and email address
Date: Wed, 19 Feb 2025 16:17:02 +0900

Update my Korean name and personal email address to my English name and
Oracle email address.

Link: https://lkml.kernel.org/r/20250219071702.964344-1-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo (Oracle) <42.hyeyoo@gmail.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dev Jain <dev.jain@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-mailmap-update-hyeonggons-name-and-email-address
+++ a/.mailmap
@@ -270,6 +270,7 @@ Hamza Mahfooz <hamzamahfooz@linux.micros
 Hanjun Guo <guohanjun@huawei.com> <hanjun.guo@linaro.org>
 Hans Verkuil <hverkuil@xs4all.nl> <hansverk@cisco.com>
 Hans Verkuil <hverkuil@xs4all.nl> <hverkuil-cisco@xs4all.nl>
+Harry Yoo <harry.yoo@oracle.com> <42.hyeyoo@gmail.com>
 Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
 Heiko Carstens <hca@linux.ibm.com> <heiko.carstens@de.ibm.com>
 Heiko Stuebner <heiko@sntech.de> <heiko.stuebner@bqreaders.com>
--- a/MAINTAINERS~maintainers-mailmap-update-hyeonggons-name-and-email-address
+++ a/MAINTAINERS
@@ -21800,7 +21800,7 @@ M:	Joonsoo Kim <iamjoonsoo.kim@lge.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Vlastimil Babka <vbabka@suse.cz>
 R:	Roman Gushchin <roman.gushchin@linux.dev>
-R:	Hyeonggon Yoo <42.hyeyoo@gmail.com>
+R:	Harry Yoo <harry.yoo@oracle.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

maintainers-mailmap-update-hyeonggons-name-and-email-address.patch

