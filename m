Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2FA77111
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735249848; cv=none; b=muBf/5Z6iJRTWjH82Mdkpu6W0HC/Nc6khChTrIQqNHyvtbZ+KGhK+XMQ8jlw1+SDTKpbvMuLf59tLZRY1PvdRNHsJJVTn+uuyfhCSG6X8UibMbO2Bjq7eLbeO4juqe70TFBdQHCvw9J5aJk7bSN7fbUanZyZxFBLJ2aLjMqF8wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735249848; c=relaxed/simple;
	bh=thCbRquCgfE2I/RUmvrokmwP2Lba7S9STg4mP7E4AxA=;
	h=Date:To:From:Subject:Message-Id; b=XogZs9gxoFSGyPoVvtwJssYcCYf9DmqYlMoV+RIbwARrvInsVmM/A1+0mjhYkDjbk57o5dKSN7pMxk8VXtysWdc+pNTdfjqPCu47BbeL1ctOdaDJygsaayZh/GIq4fsWfdTN8A45SSz2EGTSDkaXFSr8iLlMoe8/+s5Lyni8bkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KbYnAFRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KbYnAFRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5613C4CED1;
	Thu, 26 Dec 2024 21:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735249847;
	bh=thCbRquCgfE2I/RUmvrokmwP2Lba7S9STg4mP7E4AxA=;
	h=Date:To:From:Subject:From;
	b=KbYnAFRgDvt1uYH0s8zzYBlMlm55ZtG8j0YWONRV8f5PflgWciOirLsWWDm6dgXKy
	 1mml+vWlWwAvnBTXUfvMHe02AUtAgxnm32D8aHzbVLl776oXk2QkP7YSiNkADDsk+0
	 mTk0FhE1Mq7pwgeyxseeGMieHr3BE/9QJpk+EmzY=
Date: Thu, 26 Dec 2024 13:50:47 -0800
To: mm-commits@vger.kernel.org,chester.a.unal@arinc9.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-change-arınc-_nals-name-and-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20241226215047.B5613C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: change Arınç _NAL's name and email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-change-arınc-_nals-name-and-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-change-arınc-_nals-name-and-email-address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Chester A. Unal" <chester.a.unal@arinc9.com>
Subject: MAINTAINERS: change Arınç _NAL's name and email address
Date: Wed, 25 Dec 2024 15:50:41 +0300

My legal name now includes Chester. Change the name and the email address
sections to reflect that.

Link: https://lkml.kernel.org/r/20241225-for-unknown-upstream-v1-1-3e35e4d5e161@arinc9.com
Signed-off-by: Chester A. Unal <chester.a.unal@arinc9.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/MAINTAINERS~maintainers-change-arınc-_nals-name-and-email-address
+++ a/MAINTAINERS
@@ -14756,7 +14756,7 @@ F:	drivers/memory/mtk-smi.c
 F:	include/soc/mediatek/smi.h
 
 MEDIATEK SWITCH DRIVER
-M:	Arınç ÜNAL <arinc.unal@arinc9.com>
+M:	Chester A. Unal <chester.a.unal@arinc9.com>
 M:	Daniel Golle <daniel@makrotopia.org>
 M:	DENG Qingfang <dqfext@gmail.com>
 M:	Sean Wang <sean.wang@mediatek.com>
@@ -18460,7 +18460,7 @@ F:	Documentation/devicetree/bindings/pin
 F:	drivers/pinctrl/mediatek/
 
 PIN CONTROLLER - MEDIATEK MIPS
-M:	Arınç ÜNAL <arinc.unal@arinc9.com>
+M:	Chester A. Unal <chester.a.unal@arinc9.com>
 M:	Sergio Paracuellos <sergio.paracuellos@gmail.com>
 L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
 L:	linux-mips@vger.kernel.org
@@ -19504,7 +19504,7 @@ S:	Maintained
 F:	arch/mips/ralink
 
 RALINK MT7621 MIPS ARCHITECTURE
-M:	Arınç ÜNAL <arinc.unal@arinc9.com>
+M:	Chester A. Unal <chester.a.unal@arinc9.com>
 M:	Sergio Paracuellos <sergio.paracuellos@gmail.com>
 L:	linux-mips@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from chester.a.unal@arinc9.com are

maintainers-change-arınc-_nals-name-and-email-address.patch

