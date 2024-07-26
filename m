Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B53143748
	for <mm-commits@vger.kernel.org>; Fri, 26 Jul 2024 20:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722026286; cv=none; b=VIFb8QPQUwiXJyOkmXXR6VZVCeUCeuhlQoeejqeoW6yRJdM8oiiE/mS85o1KbJAn25WMIMpguZXAXvfXmTGxcs63t0M/5/QmtvycPt5YXQxBGV0v1ffnnZnAjQy4i4241HTqRXU+54MOKxHpsON0zKUeXkEPnlRjzJSaE3EsiV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722026286; c=relaxed/simple;
	bh=EHMJ8eTFstfRpY7G1rIofgVaUnhNNHKD2gOF6pCXo6Y=;
	h=Date:To:From:Subject:Message-Id; b=EjpsPNgJz43TG8TZonp/j0CSQkxTa3tEeT0M05OUQj8y6RCksbdwiHAFC7L5ejwdqgZmm7BLz0yxIIc/AOVXgWeIcGG1sInnzDon932MurEl6AHgIRYi7pUWZoN8rmyyJzzOzoI1m9EtYIaQDhqdzwat54T0ZrI7BzTd4tESh7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aSrdhJVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aSrdhJVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24757C32782;
	Fri, 26 Jul 2024 20:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722026286;
	bh=EHMJ8eTFstfRpY7G1rIofgVaUnhNNHKD2gOF6pCXo6Y=;
	h=Date:To:From:Subject:From;
	b=aSrdhJVX4pyVLaVmGYlrpg38HkKyF6IRcc+GXrIxAn+nZSQDKCmg3aN7uoi+gJ4zr
	 c6IW+M1+DnfGraWsrC1E/Lsee85Cp7JL1dr7FzRbNui8yQfWsNILPe0ts2Gnnkhhkp
	 wzH5I1ZL914R9DuhAvDu+yM1PKKLqJIWXi/P6vGU=
Date: Fri, 26 Jul 2024 13:38:05 -0700
To: mm-commits@vger.kernel.org,suzuki.poulose@arm.com,robh@kernel.org,quic_jinlmao@quicinc.com,quic_hazha@quicinc.com,quic_bjorande@quicinc.com,o.rempel@pengutronix.de,mike.leach@linaro.org,matttbe@kernel.org,matt@ranostay.sg,kuba@kernel.org,krzk+dt@kernel.org,kees@kernel.org,jikos@kernel.org,geliang@kernel.org,davem@davemloft.net,conor+dt@kernel.org,james.clark@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-mailmap-update-james-clarks-email-address.patch removed from -mm tree
Message-Id: <20240726203806.24757C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: mailmap: update James Clark's email address
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-james-clarks-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2188,7 +2188,7 @@ N:	digicolor
 ARM/CORESIGHT FRAMEWORK AND DRIVERS
 M:	Suzuki K Poulose <suzuki.poulose@arm.com>
 R:	Mike Leach <mike.leach@linaro.org>
-R:	James Clark <james.clark@arm.com>
+R:	James Clark <james.clark@linaro.org>
 L:	coresight@lists.linaro.org (moderated for non-subscribers)
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
@@ -17867,7 +17867,7 @@ F:	tools/perf/
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


