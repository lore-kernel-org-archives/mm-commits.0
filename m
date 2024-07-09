Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93311B86D4
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 21:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561039; cv=none; b=TJV4/tJuVGH38gM0RTMKqjtDcZNJiSx5LP0llg/E4nxJ41NkIDIj1jFHrdDzxtydCuHNBsiEDdtlQPxDiha89WnF7KNti5ksh2HwIS9MQ7Xe/ZLopoTDQajQZW4HQQs7I+ur3PJ/xmSwiEb0zBrVUigorkv2A2C+ZryV4/6VeQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561039; c=relaxed/simple;
	bh=crytJyZszvK3muXktbZb9IrMqHfcZlte0SO1QjamNE8=;
	h=Date:To:From:Subject:Message-Id; b=egOKdvLfex3zMLU4Kr9RoOhChRBnt3ubPaTx458U+uOoqvo5s5yuN6Ml18VXsyZssgYyCjgpOJNEUr95DMWYygHc9CcbNYvsaXbik1vX4PWvfzG+vDdXcnZB2KwY7ieKU7nuJH8w/pcaicnDM2XKkC7XD0flsaPWLhSHC7btTVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jSk5yGOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jSk5yGOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294DEC3277B;
	Tue,  9 Jul 2024 21:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720561039;
	bh=crytJyZszvK3muXktbZb9IrMqHfcZlte0SO1QjamNE8=;
	h=Date:To:From:Subject:From;
	b=jSk5yGOFFqj1vT/rnewZpxk9QuM44MEP9LCJfegxAkh+Tybh2eu1tZKZQqjpp0xPf
	 B4hvmBunKyzoLof7wDmsYYaq2WUi2pAm2Aj4uZFECqWouC4g078qmLUK2BkZ4Kg8Sb
	 CsOiv+KR0wAisfcLUHzccH3nXdZB16mnCMxNCN+o=
Date: Tue, 09 Jul 2024 14:37:18 -0700
To: mm-commits@vger.kernel.org,suzuki.poulose@arm.com,robh@kernel.org,quic_jinlmao@quicinc.com,quic_hazha@quicinc.com,quic_bjorande@quicinc.com,o.rempel@pengutronix.de,mike.leach@linaro.org,matttbe@kernel.org,matt@ranostay.sg,kuba@kernel.org,krzk+dt@kernel.org,kees@kernel.org,jikos@kernel.org,geliang@kernel.org,davem@davemloft.net,conor+dt@kernel.org,james.clark@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-update-james-clarks-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20240709213719.294DEC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: mailmap: update James Clark's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mailmap-update-james-clarks-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-update-james-clarks-email-address.patch

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
From: James Clark <james.clark@linaro.org>
Subject: MAINTAINERS: mailmap: update James Clark's email address
Date: Tue, 9 Jul 2024 11:25:10 +0100

My new address is james.clark@linaro.org

Link: https://lkml.kernel.org/r/20240709102512.31212-2-james.clark@linaro.org
Signed-off-by: James Clark <james.clark@linaro.org>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geliang Tang <geliang@kernel.org>
Cc: Hao Zhang <quic_hazha@quicinc.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Mao Jinlong <quic_jinlmao@quicinc.com>
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: Matt Ranostay <matt@ranostay.sg>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/.mailmap~maintainers-mailmap-update-james-clarks-email-address
+++ a/.mailmap
@@ -260,6 +260,7 @@ Jaegeuk Kim <jaegeuk@kernel.org> <jaegeu
 Jakub Kicinski <kuba@kernel.org> <jakub.kicinski@netronome.com>
 James Bottomley <jejb@mulgrave.(none)>
 James Bottomley <jejb@titanic.il.steeleye.com>
+James Clark <james.clark@linaro.org> <james.clark@arm.com>
 James E Wilson <wilson@specifix.com>
 James Hogan <jhogan@kernel.org> <james@albanarts.com>
 James Hogan <jhogan@kernel.org> <james.hogan@imgtec.com>
--- a/MAINTAINERS~maintainers-mailmap-update-james-clarks-email-address
+++ a/MAINTAINERS
@@ -2157,7 +2157,7 @@ N:	digicolor
 ARM/CORESIGHT FRAMEWORK AND DRIVERS
 M:	Suzuki K Poulose <suzuki.poulose@arm.com>
 R:	Mike Leach <mike.leach@linaro.org>
-R:	James Clark <james.clark@arm.com>
+R:	James Clark <james.clark@linaro.org>
 L:	coresight@lists.linaro.org (moderated for non-subscribers)
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
@@ -17589,7 +17589,7 @@ F:	tools/perf/
 PERFORMANCE EVENTS TOOLING ARM64
 R:	John Garry <john.g.garry@oracle.com>
 R:	Will Deacon <will@kernel.org>
-R:	James Clark <james.clark@arm.com>
+R:	James Clark <james.clark@linaro.org>
 R:	Mike Leach <mike.leach@linaro.org>
 R:	Leo Yan <leo.yan@linux.dev>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
_

Patches currently in -mm which might be from james.clark@linaro.org are

maintainers-mailmap-update-james-clarks-email-address.patch
dt-bindings-arm-update-james-clarks-email-address.patch

