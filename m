Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23AB2BAF9
	for <mm-commits@vger.kernel.org>; Sat, 11 Oct 2025 18:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760206051; cv=none; b=IZj0/t/0hDA3RAMiuWrbWPA/Ukb18LGWhczq0hl5vLsSqNYqzuVDM8q3HMJu/3sRxRnvP95jQ0fdO9nxymVCiDmi7gjQkwxCJYrrsXgaX/yAva81JEeDVqjI+saDYINX3ZZv7VaIgoyGDeb2OZ1lN2AiGG1EZ0gbhVYfvzf18B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760206051; c=relaxed/simple;
	bh=3Y399hCb0Z4OatMNTiSK/Z2crYRlGkpjftk8joDez4I=;
	h=Date:To:From:Subject:Message-Id; b=Vj8SzbsiddqGB3nHPKcCJqfEBi6ZOq2yqQgPFghaa6ty3mNInLa8Ck0MW+iQSnfQSuLlzECFf7iX4pvtECX9xp7lV9l7AWJvZFnACQojWi+iSC2HTuoIM1rPayxA+QFVFYjA0jkHqviXj9dBpTkYx6T+APHC7VfhLtSeouD5ymI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jZCIftL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jZCIftL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A739C4CEF4;
	Sat, 11 Oct 2025 18:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760206050;
	bh=3Y399hCb0Z4OatMNTiSK/Z2crYRlGkpjftk8joDez4I=;
	h=Date:To:From:Subject:From;
	b=jZCIftL6J/fV+tLWPhTMHrOYHYGSKu3MC9OAuAHpiCqZ8k4z6xqvv9vaGb7Z5qZ+E
	 MovttwTHGGcgftsSZhhQU9XgP3ymaJzH/h9tfJQmZ45EBp2UMifbyNGbzN+zZJ5wik
	 srOlWneJr8VwE3R3/BExyNDXTAaDxAfDNKfVqN28=
Date: Sat, 11 Oct 2025 11:07:29 -0700
To: mm-commits@vger.kernel.org,martink@posteo.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-apply-name-and-email-address-changes-for-martin.patch added to mm-nonmm-unstable branch
Message-Id: <20251011180730.6A739C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: apply name and email address changes for Martin
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-apply-name-and-email-address-changes-for-martin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-apply-name-and-email-address-changes-for-martin.patch

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
Subject: MAINTAINERS: apply name and email address changes for Martin
Date: Sat, 11 Oct 2025 15:59:39 +0000

Update to new surname addition and currently used email address.

Link: https://lkml.kernel.org/r/20251011155903.7442-2-martink@posteo.de
Signed-off-by: Martin Kepplinger-Novaković <martink@posteo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-apply-name-and-email-address-changes-for-martin
+++ a/MAINTAINERS
@@ -11563,7 +11563,7 @@ T:	git git://linuxtv.org/media.git
 F:	drivers/media/i2c/hi556.c
 
 HYNIX HI846 SENSOR DRIVER
-M:	Martin Kepplinger <martin.kepplinger@puri.sm>
+M:	Martin Kepplinger-Novakovic <martink@posteo.de>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/i2c/hi846.c
@@ -15516,7 +15516,7 @@ F:	include/media/imx.h
 MEDIA DRIVERS FOR FREESCALE IMX7/8
 M:	Rui Miguel Silva <rmfrfs@gmail.com>
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
-M:	Martin Kepplinger <martin.kepplinger@puri.sm>
+M:	Martin Kepplinger-Novakovic <martink@posteo.de>
 R:	Purism Kernel Team <kernel@puri.sm>
 L:	linux-media@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from martink@posteo.de are

mailmap-update-name-and-email-addresses.patch
credits-update-martins-information.patch
maintainers-apply-name-and-email-address-changes-for-martin.patch

