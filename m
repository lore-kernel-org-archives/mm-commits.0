Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EA95227
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 20:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759870159; cv=none; b=CD3a+Ygrv4LYkzr5wLdMGb6rkzd9ozDYckJwHhvO42JoKDY7jkGgyHFaEyoNrFoeo9rJRSA+ybbWAbVKwoDhSCDOtanvDtgB51vYCxyxPh7rd6ifs5pjRtSsCW1l4eZPwf/T0/rqoRT6Z+TR+8u4EfEy3doMS2ZcdupRFJd82hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759870159; c=relaxed/simple;
	bh=eFob/itTur7j4hOAD0QZl8yUqerUa6at18whCDE+sqk=;
	h=Date:To:From:Subject:Message-Id; b=V1HcnpZPy1IBzxfKGxPdlEahYDjhPtNy2S01bRMDt27ZvdRfTJHH0DwD0Tlj6IxFqdF+tL0c9yF9dv3usvehvoB63LK3NSm0JPliIEJFFNgLc68W3Eakm2fpx7BHa14EIZ9bv4IQF8p70Y7fHoAt1HkicGlLLAjhxxTCNjc6W2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yaPdSqD1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yaPdSqD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB05C4CEF1;
	Tue,  7 Oct 2025 20:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759870158;
	bh=eFob/itTur7j4hOAD0QZl8yUqerUa6at18whCDE+sqk=;
	h=Date:To:From:Subject:From;
	b=yaPdSqD1CHM/SpTdMFQ0aiKbOcb1m+03xsQEwC3I6P9ru66wQ/tG3J+9fxNYuJ+r8
	 GXTHlcsfOa1qJ+4d3OCq5eOZ9Yb8NcxJjgw73IKi+adIs0K4Sak0bjikVEoMlNdx6l
	 BpJBSpB1FzQ3eApJTXZpjILVXs8BdlJUtxlbD/rA=
Date: Tue, 07 Oct 2025 13:49:18 -0700
To: mm-commits@vger.kernel.org,uajain@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-mailmap-update-umangs-email-address.patch removed from -mm tree
Message-Id: <20251007204918.9EB05C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS, .mailmap: update Umang's email address
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-umangs-email-address.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Umang Jain <uajain@igalia.com>
Subject: MAINTAINERS, .mailmap: update Umang's email address
Date: Mon, 29 Sep 2025 13:10:24 +0530

Map my new professional email address in .mailmap and also update
the IMX283 driver entry with the same.

At the same time, update my role to a reviewer for the IMX283 driver.

Link: https://lkml.kernel.org/r/20250929074025.84407-1-uajain@igalia.com
Signed-off-by: Umang Jain <uajain@igalia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-mailmap-update-umangs-email-address
+++ a/.mailmap
@@ -803,6 +803,7 @@ Tvrtko Ursulin <tursulin@ursulin.net> <t
 Tvrtko Ursulin <tursulin@ursulin.net> <tvrtko@ursulin.net>
 Tycho Andersen <tycho@tycho.pizza> <tycho@tycho.ws>
 Tzung-Bi Shih <tzungbi@kernel.org> <tzungbi@google.com>
+Umang Jain <uajain@igalia.com> <umang.jain@ideasonboard.com>
 Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
 Uwe Kleine-König <u.kleine-koenig@baylibre.com> <ukleinek@baylibre.com>
 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
--- a/MAINTAINERS~maintainers-mailmap-update-umangs-email-address
+++ a/MAINTAINERS
@@ -23882,7 +23882,7 @@ F:	drivers/media/i2c/imx274.c
 
 SONY IMX283 SENSOR DRIVER
 M:	Kieran Bingham <kieran.bingham@ideasonboard.com>
-M:	Umang Jain <umang.jain@ideasonboard.com>
+R:	Umang Jain <uajain@igalia.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 T:	git git://linuxtv.org/media.git
_

Patches currently in -mm which might be from uajain@igalia.com are


