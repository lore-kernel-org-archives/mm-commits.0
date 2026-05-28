Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F453546ED
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 21:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780002712; cv=none; b=PRMEFINADlh/TORagEUUnKJrUYJ8bgWXghdGtQVitDj8m5B3hldTx6DzepLWKJDHZZmmCpffF/Y1WTISZHCdKxO5OGVColnXGuK25Ao3IgG2GuhswB5FLa4bIPwR6ndWfBG3Lmj87dlhrREIQ5uRlsjIq2CrtYhKYvfcTdLx/Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780002712; c=relaxed/simple;
	bh=3x8fDakTJdygWwBnTKyYM0p0s+WtPMuy/0yIFOAecfU=;
	h=Date:To:From:Subject:Message-Id; b=T7wQziSTuTsZXeVjGtZTckiHXO1NfLilyTX4HHjLK0r9S4vjgN5lFnZ+DardNA2w0IYIOBRcHpUUO8tR2Qr5xTCDzR+zzyvpS2KwT+EzVixfz3viIJCw1+jLAqUdXIhoBJ8mV2Cs4rfvCXRj0BttN0Eri7Q5ql1b7/vZfNsvR5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QA1ZUoZr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QA1ZUoZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C311F000E9;
	Thu, 28 May 2026 21:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780002710;
	bh=6vV/Wh4WfZExNSqm4qdHhKtzYLjxrpsA1o9XkeI8QHs=;
	h=Date:To:From:Subject;
	b=QA1ZUoZrJDiVrCMh3uJ66DMbd3xpGcf4s9S2+9/iWhLgdgLcEJ8miYvTESDQKyu5E
	 zYBpDbq/0DzKWPuMtncKDylSl8+AiV1Xitam4i8qvBEiTnfNAiWO/APbtlWbNy/pvG
	 zjdaLa2rE26UftwgTUMH/Xv+G8foQxPc10kuysF8=
Date: Thu, 28 May 2026 14:11:49 -0700
To: mm-commits@vger.kernel.org,baoquan.he@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-baoquan-hes-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20260528211150.25C311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update Baoquan He's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-baoquan-hes-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-baoquan-hes-email-address.patch

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
From: Baoquan He <baoquan.he@linux.dev>
Subject: MAINTAINERS: update Baoquan He's email address
Date: Thu, 28 May 2026 21:14:54 +0800

I will switch to use @linux.dev mailbox, update all entries in
MAINTAINERS.  And map the address in .mailmap.

Link: https://lore.kernel.org/20260528131454.1996752-1-baoquan.he@linux.dev
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/.mailmap~maintainers-update-baoquan-hes-email-address
+++ a/.mailmap
@@ -126,6 +126,7 @@ Baolin Wang <baolin.wang@linux.alibaba.c
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang@spreadtrum.com>
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang@unisoc.com>
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang7@gmail.com>
+Baoquan He <baoquan.he@linux.dev> <bhe@redhat.com>
 Barry Song <baohua@kernel.org> <21cnbao@gmail.com>
 Barry Song <baohua@kernel.org> <v-songbaohua@oppo.com>
 Barry Song <baohua@kernel.org> <song.bao.hua@hisilicon.com>
--- a/MAINTAINERS~maintainers-update-baoquan-hes-email-address
+++ a/MAINTAINERS
@@ -13864,7 +13864,7 @@ F:	scripts/Makefile.kcsan
 
 KDUMP
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Baoquan He <bhe@redhat.com>
+M:	Baoquan He <baoquan.he@linux.dev>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 M:	Pratyush Yadav <pratyush@kernel.org>
@@ -14183,7 +14183,7 @@ F:	include/linux/kernfs.h
 
 KEXEC
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Baoquan He <bhe@redhat.com>
+M:	Baoquan He <baoquan.he@linux.dev>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 M:	Pratyush Yadav <pratyush@kernel.org>
@@ -17036,7 +17036,7 @@ M:	Chris Li <chrisl@kernel.org>
 M:	Kairui Song <kasong@tencent.com>
 R:	Kemeng Shi <shikemeng@huaweicloud.com>
 R:	Nhat Pham <nphamcs@gmail.com>
-R:	Baoquan He <bhe@redhat.com>
+R:	Baoquan He <baoquan.he@linux.dev>
 R:	Barry Song <baohua@kernel.org>
 R:	Youngjun Park <youngjun.park@lge.com>
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from baoquan.he@linux.dev are

maintainers-update-baoquan-hes-email-address.patch

