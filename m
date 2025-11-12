Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D62517A2F0
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908574; cv=none; b=WjS2qfcLztHzgumNia7TQ5KzyS+C4kROIBGorKskeBsuO86kGGWkimDsLbKZJsUgklpZpjODjoH95DgehnZ89NXEKFq4jyVkKSYxGBAaHpVbgUifEwb1jea2107vVAMuI3G9G5QTJbWqdH8PbaPg5WtR675O+qgQuGKRjUPNpjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908574; c=relaxed/simple;
	bh=UWH9X2BStxsM99NyR4Vdldpb7dXM0FXwYGW+yZ4Ooik=;
	h=Date:To:From:Subject:Message-Id; b=WXypqwGxzJ9cMIJbqo/HGUSSQhwTwGB10dFYIT65R7bsZptVCN6Ud8fsE5rlJfUSqEcYTatcP8yeDxMsBsMPzGaSJEtf9Hhk/G6LvZymczMkymDQsiKryl1o4j7ucF2j8hgn6yOhf1ozP/iNitBmiKlsPRcTWQHjcuy28vl+tKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qIvzU2CA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qIvzU2CA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540CAC113D0;
	Wed, 12 Nov 2025 00:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908574;
	bh=UWH9X2BStxsM99NyR4Vdldpb7dXM0FXwYGW+yZ4Ooik=;
	h=Date:To:From:Subject:From;
	b=qIvzU2CA5sjWAgqu8rvMped33KyAmWODc0PFDEl/z5KQmoN0LRy5cHpXTOcdCtgsh
	 SU7ijAcVvpwviqQZm0AkkzkYoo+7jGm0GNC3MLWILK6MX4IvHjH427B4Fmv+bOQ1wj
	 FyHLGmwVj9qrETkGiMzAnrbDk6/vuhgqGB/4Ual4=
Date: Tue, 11 Nov 2025 16:49:33 -0800
To: mm-commits@vger.kernel.org,martink@posteo.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-apply-name-and-email-address-changes-for-martin.patch removed from -mm tree
Message-Id: <20251112004934.540CAC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: apply name and email address changes for Martin
has been removed from the -mm tree.  Its filename was
     maintainers-apply-name-and-email-address-changes-for-martin.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -11581,7 +11581,7 @@ T:	git git://linuxtv.org/media.git
 F:	drivers/media/i2c/hi556.c
 
 HYNIX HI846 SENSOR DRIVER
-M:	Martin Kepplinger <martin.kepplinger@puri.sm>
+M:	Martin Kepplinger-Novakovic <martink@posteo.de>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/i2c/hi846.c
@@ -15553,7 +15553,7 @@ F:	include/media/imx.h
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


