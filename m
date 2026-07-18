Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F6A3264C4
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 20:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784406179; cv=none; b=lkQeJGmwnkG0l/kNIIx4LeLx+K+C0Shh2X6Eh7SFpxMHFV4ar2k8OhPLQn2vAykgeAvDsnNjyFfpaoR9tKCKTluJ7B2koipca6LDWNMQWcv+p6mXikiEqrz3ghAso7dhx5fyRkUZ+iQQC208mSA7dbhg7T2dE+ZsSvwRXbgXLPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784406179; c=relaxed/simple;
	bh=RaFSVCqry1rnITNwskPW5O4GflUA4cTKXd7Ql5rX5vo=;
	h=Date:To:From:Subject:Message-Id; b=gaJorFEv1psqso61uAZaRzASBltEheQyh0K0mSpaKhlsNf0xRl5CIFjeZMewxLowxYLFfGrzz82fdI8fM6MQ64NYEZM+JY8KSx3OX3c1lja8HfmIT3Wd2svkKi3Xn+g6F8nhuMRT86Hls6gxhVFTKG4b9MaItw1WUel2n7L7Mwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gDYoD0Qx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gDYoD0Qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0BF1F000E9;
	Sat, 18 Jul 2026 20:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784406177;
	bh=/Lh9+ZB0MlsE2TiD9dxUk+0AUK62VXHxB4151XCksa0=;
	h=Date:To:From:Subject;
	b=gDYoD0Qx5cvqyve/8UfdN4BW9RXax/VoP7aip5B1OX5LLhrmt1UJq7nehnEP+s3DK
	 87nf3FtEm6KC2BdBMKPYMdSS+H6oe3diWmR6APAnezWcCgK/1hDB+udO1vKACamcwk
	 1PYvBA+XUwKM5XlNn4+e3JoPx1DwNz3/HjXdOh8Y=
Date: Sat, 18 Jul 2026 13:22:57 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,ndesaulniers@google.com,martink@posteo.de,kuba@kernel.org,irogers@google.com,catalin.marinas@arm.com,peter@pcc.me.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mailmap-update-email-address-for-peter-collingbourne.patch added to mm-hotfixes-unstable branch
Message-Id: <20260718202257.AC0BF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64, mailmap: update email address for Peter Collingbourne
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     arm64-mailmap-update-email-address-for-peter-collingbourne.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mailmap-update-email-address-for-peter-collingbourne.patch

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
From: Peter Collingbourne <peter@pcc.me.uk>
Subject: arm64, mailmap: update email address for Peter Collingbourne
Date: Sat, 18 Jul 2026 10:29:23 -0700

I am no longer at Google.

Link: https://lore.kernel.org/20260718172923.8297-1-peter@pcc.me.uk
Signed-off-by: Peter Collingbourne <peter@pcc.me.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap                        |    1 +
 arch/arm64/kernel/pi/relocate.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/pi/relocate.c~arm64-mailmap-update-email-address-for-peter-collingbourne
+++ a/arch/arm64/kernel/pi/relocate.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 // Copyright 2023 Google LLC
 // Authors: Ard Biesheuvel <ardb@google.com>
-//          Peter Collingbourne <pcc@google.com>
+//          Peter Collingbourne <peter@pcc.me.uk>
 
 #include <linux/elf.h>
 #include <linux/init.h>
--- a/.mailmap~arm64-mailmap-update-email-address-for-peter-collingbourne
+++ a/.mailmap
@@ -691,6 +691,7 @@ Paulo Alcantara <pc@manguebit.org> <palc
 Paulo Alcantara <pc@manguebit.org> <pc@manguebit.com>
 Pavankumar Kondeti <quic_pkondeti@quicinc.com> <pkondeti@codeaurora.org>
 Peter A Jonsson <pj@ludd.ltu.se>
+Peter Collingbourne <peter@pcc.me.uk> <pcc@google.com>
 Peter Hilber <peter.hilber@oss.qualcomm.com> <quic_philber@quicinc.com>
 Peter Oruba <peter.oruba@amd.com>
 Peter Oruba <peter@oruba.de>
_

Patches currently in -mm which might be from peter@pcc.me.uk are

arm64-mailmap-update-email-address-for-peter-collingbourne.patch

