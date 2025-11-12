Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D1E14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908574; cv=none; b=QxhhYQ6knxgMqV/7MCgdBwv1Tv9D9PrGJYb3z41MU/X2cxfYQQFt4HUXaOR3Nrwp39GalCOqK6dvE6IpaAwOwo2k+/5rhQWIReGxvODkp+DhHQ5xZzrbRap2o0tKFzNmZAt4QWEl7njMT5qStKQGyGB2/iNVHQOG9cHTT3KydY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908574; c=relaxed/simple;
	bh=pzn/JG58kXEC1vD9Hfkhwy7jTs2qfY/6r1iEFTiawMI=;
	h=Date:To:From:Subject:Message-Id; b=JgYYKVfbPWDsBGk/6XG0Ae8dNiiPLX/9cDEebUpLAARqRuo9tBswgtCIAs2IUtCfQHp6T0kb3LLiurn4Jwwt9Ve2O95uIHxyo8RCoq9XmhuioEhPmOqdh69Z+qdu/q9r7o+sLrBdTvPTD6kwfjU43QIy7I5ayjBzAuws7Dkye40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XfCuiedF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XfCuiedF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1431EC19423;
	Wed, 12 Nov 2025 00:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908573;
	bh=pzn/JG58kXEC1vD9Hfkhwy7jTs2qfY/6r1iEFTiawMI=;
	h=Date:To:From:Subject:From;
	b=XfCuiedFNtfm9o194/XYcq1tyUPx+NpQI3HOpFGEy9R0S9wdufKjlFqLUBffez15w
	 r/Cy0bgD7lNmJjo83DCU9V2jRcT/06YKwk3eAC33Zuq1wjJRdQSPpN2EoU1SnTJv5g
	 3/FNlGE8rhFmO1pfugiB4TaaqYUVbI0Zrp7MYcp8=
Date: Tue, 11 Nov 2025 16:49:32 -0800
To: mm-commits@vger.kernel.org,martink@posteo.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] credits-update-martins-information.patch removed from -mm tree
Message-Id: <20251112004933.1431EC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: CREDITS: update Martin's information
has been removed from the -mm tree.  Its filename was
     credits-update-martins-information.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2056,16 +2056,15 @@ S: Korte Heul 95
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


