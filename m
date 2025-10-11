Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120752BAF9
	for <mm-commits@vger.kernel.org>; Sat, 11 Oct 2025 18:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760206049; cv=none; b=ZfxfZrwPV8of3PcP6VShEyM8ijyJ+zv6vlgvxv1ZFUmaBk8u9ViM3t6FDmcpNx3cDhNxRKCPiqJN501KpjT4E5YIMhAS3ZiB8bCNbaJPwUsgvLB1YknJQPlZBMMvB0lZfkx6yP0+5yKFbqEpIMY1p9J4vQFAyd183tjJtdHlZ2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760206049; c=relaxed/simple;
	bh=ubgDomZSPRam0l6+XvHoBiu114RgNNMporADYtG1IlI=;
	h=Date:To:From:Subject:Message-Id; b=KTFyivTkwJwB1nneWOzj9h7rOewa5BuKyLNtZZJ99C167NKxgb85KTvsBCQzDKioVDr8XUGG9/3VH0Ehdrsxt/yb94Epj+zs0Qxg7JmfDXQYWW6NNfVgURxkV137R9kClVbwU8J6whVT9G3AtHLr425cxDMm4ktIvRXL1Vi/8YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZE+S2zjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZE+S2zjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814F1C4CEFE;
	Sat, 11 Oct 2025 18:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760206048;
	bh=ubgDomZSPRam0l6+XvHoBiu114RgNNMporADYtG1IlI=;
	h=Date:To:From:Subject:From;
	b=ZE+S2zjTDyJQMs60AAvR8LurzyUwBprfNbm3/cBC458cMgMTS0vYhPKFwSRlfy0fj
	 2EruMZgdSkVcY5s2ZWoaMXovYoI4aiBcCHjffYCI2XJVpX5XJoCHvtS8BSZ78bWx2i
	 n3P0lWj+FveFnZELRZtsyeQK3jDS7LN6AwTPptZs=
Date: Sat, 11 Oct 2025 11:07:27 -0700
To: mm-commits@vger.kernel.org,martink@posteo.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + credits-update-martins-information.patch added to mm-nonmm-unstable branch
Message-Id: <20251011180728.814F1C4CEFE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: CREDITS: update Martin's information
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     credits-update-martins-information.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/credits-update-martins-information.patch

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
From: Martin Kepplinger-Novaković <martink@posteo.de>
Subject: CREDITS: update Martin's information
Date: Sat, 11 Oct 2025 15:59:39 +0000

Surname, address, email and the description changed. Apply these updates.

Link: https://lkml.kernel.org/r/20251011155903.7442-3-martink@posteo.de
Signed-off-by: Martin Kepplinger-Novaković <martink@posteo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/CREDITS~credits-update-martins-information
+++ a/CREDITS
@@ -2052,16 +2052,15 @@ S: Korte Heul 95
 S: 1403 ND  BUSSUM
 S: The Netherlands
 
-N: Martin Kepplinger
+N: Martin Kepplinger-Novakovic
 E: martink@posteo.de
-E: martin.kepplinger@puri.sm
-W: http://www.martinkepplinger.com
 P: 4096R/5AB387D3 F208 2B88 0F9E 4239 3468  6E3F 5003 98DF 5AB3 87D3
 D: mma8452 accelerators iio driver
 D: pegasus_notetaker input driver
+D: imx8m media and hi846 sensor driver
 D: Kernel fixes and cleanups
-S: Garnisonstraße 26
-S: 4020 Linz
+S: Keplerstr. 6
+S: 4050 Traun
 S: Austria
 
 N: Karl Keyte
_

Patches currently in -mm which might be from martink@posteo.de are

mailmap-update-name-and-email-addresses.patch
credits-update-martins-information.patch
maintainers-apply-name-and-email-address-changes-for-martin.patch

