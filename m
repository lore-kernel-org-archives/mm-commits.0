Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442583CE4B6
	for <mm-commits@vger.kernel.org>; Fri, 20 Mar 2026 17:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774028039; cv=none; b=pQwcm3u57zTcGAIJqj+bzSIp1h6vROkD2yte5rnG1/4f0qjWl/eCDu5xoSE1g0J3a2q5cLTXYGDiIpsbrc7n3YXBbqJmI4QJ3077hW3ksLIU0RgIIwZu39JhEHZZNG2ZsorknUI74mjT3ZrZstanm3wGcFLsN25b8VBEohM0Fos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774028039; c=relaxed/simple;
	bh=Dvvszp998IJMjAJod4AuA4KB/r1HQ4zUXwrc8XnKjI0=;
	h=Date:To:From:Subject:Message-Id; b=dfDnGhVRiJMoZnMpKFtqDwFO8FwXKgki9r6zlfIUM7+cx6WlX5Bick+gL0WcuV4AKnh09Rz08bCErmnfDFrKHCpo3i6Lo3wLefnKidWsWzxBTf9meazdEZPYXgmRqA0IMAnB60PNbH3iyDXbq4LZ/LgDIjTGRhrW4bl09w8JoTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nHlSk+Xt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nHlSk+Xt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED62DC19425;
	Fri, 20 Mar 2026 17:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774028039;
	bh=Dvvszp998IJMjAJod4AuA4KB/r1HQ4zUXwrc8XnKjI0=;
	h=Date:To:From:Subject:From;
	b=nHlSk+XtWYBUhT6s8pyIASQLU3lpO6/bdSe4RbLpwQ6IYmZ6G7A1kxD60xzv6XcjB
	 Z3C9LkhdaSEifDM51yfFwFHhYQSTCqng791Aq1oKH1Rd91TPXAtyx8/jLrRBaugbV3
	 9BQf/CW89LqveqFbVV7Tf53ts150eDwtV6CtvQjQ=
Date: Fri, 20 Mar 2026 10:33:58 -0700
To: mm-commits@vger.kernel.org,harry@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-update-email-address-for-harry-yoo.patch added to mm-hotfixes-unstable branch
Message-Id: <20260320173358.ED62DC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS, mailmap: update email address for Harry Yoo
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mailmap-update-email-address-for-harry-yoo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-update-email-address-for-harry-yoo.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Subject: MAINTAINERS, mailmap: update email address for Harry Yoo
Date: Fri, 20 Mar 2026 21:59:25 +0900

Update my email address to harry@kernel.org.

Link: https://lkml.kernel.org/r/20260320125925.2259998-1-harry@kernel.org
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/.mailmap~maintainers-mailmap-update-email-address-for-harry-yoo
+++ a/.mailmap
@@ -316,6 +316,7 @@ Hans Verkuil <hverkuil@kernel.org> <hver
 Hans Verkuil <hverkuil@kernel.org> <hansverk@cisco.com>
 Hao Ge <hao.ge@linux.dev> <gehao@kylinos.cn>
 Harry Yoo <harry.yoo@oracle.com> <42.hyeyoo@gmail.com>
+Harry Yoo <harry@kernel.org> <harry.yoo@oracle.com>
 Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
 Heiko Carstens <hca@linux.ibm.com> <heiko.carstens@de.ibm.com>
 Heiko Stuebner <heiko@sntech.de> <heiko.stuebner@bqreaders.com>
--- a/MAINTAINERS~maintainers-mailmap-update-email-address-for-harry-yoo
+++ a/MAINTAINERS
@@ -16875,7 +16875,7 @@ M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Rik van Riel <riel@surriel.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@kernel.org>
-R:	Harry Yoo <harry.yoo@oracle.com>
+R:	Harry Yoo <harry@kernel.org>
 R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -24341,7 +24341,7 @@ F:	drivers/nvmem/layouts/sl28vpd.c
 
 SLAB ALLOCATOR
 M:	Vlastimil Babka <vbabka@kernel.org>
-M:	Harry Yoo <harry.yoo@oracle.com>
+M:	Harry Yoo <harry@kernel.org>
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Hao Li <hao.li@linux.dev>
 R:	Christoph Lameter <cl@gentwo.org>
_

Patches currently in -mm which might be from harry@kernel.org are

maintainers-mailmap-update-email-address-for-harry-yoo.patch

