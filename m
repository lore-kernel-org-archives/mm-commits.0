Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5814A26158B
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 00:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785285490; cv=none; b=eh/VRUxIL0M9QZNVngdz5VcnEKUvRxMnTAXttriPueOXchCJ4J3wcDbDmBafxxCOjubMIL4C2YfXKOD5VTIsZn6CjVo0Nf4EI1g2H3ugaqShKBAdBloBbtKKnEIiK5mrDdHLODuZzs9893hmQHUVuZkd1ahGuSDTeD8KuqhIrQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785285490; c=relaxed/simple;
	bh=gm5QRn36GW/JcQGbXngVqh3kFEPvTyi5bet7e9za16A=;
	h=Date:To:From:Subject:Message-Id; b=AyloV7yOUBJGHH/OEStxXuI6muCxYLfrMccC2eo+Hd0Vg4TC0JkG/CWxiGsktcvOQcjlSlFujrhF5vYu9lAGOS7k0vlWsx5WO1z4z1YsbN1hhoqHyDj9qZVEUUHdJqepFuuzcBSHdO0tXl2dLlO/Y8PnBqHYM4G8ax7O0AWJkqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u5xR7U1P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u5xR7U1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3001B1F00A3A;
	Wed, 29 Jul 2026 00:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785285489;
	bh=VIzMSfGDhYtiDe1elP13jzkWLOxlpImNFh/fxJ5PhBo=;
	h=Date:To:From:Subject;
	b=u5xR7U1PAM9vsMSCXfKc2QijtoTH/8SJ4eEsOGey1bpia2Hh3l6ka3bM88Qb7JXYr
	 87u+VwpiluuaKirLGWaNumWIQ1Uo2VSV1s+claHjDoubkcRI3eiICXJc4iuUaqRHdi
	 ZWmYT6P1ULIgVCYx0z/XHNFrV3vPR1PwLhKgyiJE=
Date: Tue, 28 Jul 2026 17:38:08 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,ndesaulniers@google.com,martink@posteo.de,kuba@kernel.org,irogers@google.com,catalin.marinas@arm.com,peter@pcc.me.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] arm64-mailmap-update-email-address-for-peter-collingbourne.patch removed from -mm tree
Message-Id: <20260729003809.3001B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64, mailmap: update email address for Peter Collingbourne
has been removed from the -mm tree.  Its filename was
     arm64-mailmap-update-email-address-for-peter-collingbourne.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -696,6 +696,7 @@ Paulo Alcantara <pc@manguebit.org> <palc
 Paulo Alcantara <pc@manguebit.org> <pc@manguebit.com>
 Pavankumar Kondeti <quic_pkondeti@quicinc.com> <pkondeti@codeaurora.org>
 Peter A Jonsson <pj@ludd.ltu.se>
+Peter Collingbourne <peter@pcc.me.uk> <pcc@google.com>
 Peter Hilber <peter.hilber@oss.qualcomm.com> <quic_philber@quicinc.com>
 Peter Oruba <peter.oruba@amd.com>
 Peter Oruba <peter@oruba.de>
_

Patches currently in -mm which might be from peter@pcc.me.uk are


