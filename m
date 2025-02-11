Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812D8267735
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 22:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739312435; cv=none; b=XcT6sDht16GpY+lh2CneiimI5AmprW1QEUuDa2v5N06PPhAkPHbnZ5ZGfIdobcHO1vc5nfL+gr1DmO7nDIMMR/0T4zTH96Yfdm7curoDlW3TOs2ctADyaZblQ/4KFoODxJoRkBXRGpu/PSrXB83H5SQABzQgl6J+744o/MKoANE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739312435; c=relaxed/simple;
	bh=QTA2sBgnj58iS/XABuNgMcLD3Fdr7hJGR1eUtXX5hyo=;
	h=Date:To:From:Subject:Message-Id; b=OceLNPWki75fnbDjySLIC5bsZuYWihELdiouHJb7jCF6Sz/Il6s0OYaYd68v1nHpsFvzKk2kd+/OD9WxMSDKGHUi3ZoaixDAZHmI7mMscoOAr7q8VZMJrD3ikxG/N+J1TsOLbWuIFz2kR9NZstRkJzuwxmZ/bbranr+Ia1hVCSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DyV8ahD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DyV8ahD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43A6C4CEDD;
	Tue, 11 Feb 2025 22:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739312434;
	bh=QTA2sBgnj58iS/XABuNgMcLD3Fdr7hJGR1eUtXX5hyo=;
	h=Date:To:From:Subject:From;
	b=DyV8ahD3Cp47Bfj035/KyHPK5Q5GBmYSSf7r7sLI2VCMf4xmrK8/p5bMJC+7P7LvG
	 akazpbQExv5n9TLeGdocPUWNoCrnBpAjt1mCLWIzchvIYlvVZGtp29A9y1aq8cEUY8
	 dpn8uFXL4AbU1axBN3iCHaq/BTBYA9eYCaKmIVV4=
Date: Tue, 11 Feb 2025 14:20:34 -0800
To: mm-commits@vger.kernel.org,ndesaulniers@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-my-entry.patch added to mm-unstable branch
Message-Id: <20250211222034.D43A6C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update Nick's entry
has been added to the -mm mm-unstable branch.  Its filename is
     mailmap-update-my-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-my-entry.patch

This patch will later appear in the mm-unstable branch at
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
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: mailmap: update Nick's entry
Date: Tue, 11 Feb 2025 13:21:17 -0800

Link: https://lkml.kernel.org/r/20250211212117.3195265-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-my-entry
+++ a/.mailmap
@@ -533,6 +533,7 @@ Nicholas Piggin <npiggin@gmail.com> <npi
 Nicholas Piggin <npiggin@gmail.com> <npiggin@suse.de>
 Nicholas Piggin <npiggin@gmail.com> <nickpiggin@yahoo.com.au>
 Nicholas Piggin <npiggin@gmail.com> <piggin@cyberone.com.au>
+Nick Desaulniers <nick.desaulniers+lkml@gmail.com> <ndesaulniers@google.com>
 Nicolas Ferre <nicolas.ferre@microchip.com> <nicolas.ferre@atmel.com>
 Nicolas Pitre <nico@fluxnic.net> <nicolas.pitre@linaro.org>
 Nicolas Pitre <nico@fluxnic.net> <nico@linaro.org>
_

Patches currently in -mm which might be from ndesaulniers@google.com are

mailmap-update-my-entry.patch

