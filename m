Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1859D1B86D4
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 21:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561042; cv=none; b=DaSxAZwPjZAdy/+FBiH9bDd9OMSWpVqyeEgm6VZMiWolvDt13rHL0bWqMIrfN/vXhwHwvEtXixiswmbfcbPkudVoZcHKrlE5gY0ivl28SxTaxhUBoDmZ2HkEZc8+qWObmA+TTXDmFC8M/yRnal+CTtsaPvQmFiZyHx3wZWkWPd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561042; c=relaxed/simple;
	bh=nthK0lhLyRCIOLW7NtmrQ2JMbUm7pRWZNmuoGRxsIW0=;
	h=Date:To:From:Subject:Message-Id; b=pBSBx6G0twJx87XtYvcnpjaRNlexgSdTQPdnnUCNN/7678OHllsgyqZn3VwSFZfp66iWeKZ2Y2BuTpf5YrlSfptcwJRLKjy6MOd2HNunEa214QD7HMkKoh1b9I8Iar2cdu1LGj1J0vzTdHfBeQr5KfJNoN0kgaoWUsBLI5IsKXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pzLw6an9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pzLw6an9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A207C3277B;
	Tue,  9 Jul 2024 21:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720561041;
	bh=nthK0lhLyRCIOLW7NtmrQ2JMbUm7pRWZNmuoGRxsIW0=;
	h=Date:To:From:Subject:From;
	b=pzLw6an9OpCtT6DTNWO6K+OqMZWNmYuWmTK0e88chFJILR+3hdRUPgnuLCcSz6jgh
	 epGISOf8fI4gvym9a7jWthpbGng819sFLdHWpSO5AcSmEMPufZW5mASAuHTRwHzn4v
	 S+m6MNII+KvCguaReEZNC5va9/xm1xFbgupZPfcs=
Date: Tue, 09 Jul 2024 14:37:20 -0700
To: mm-commits@vger.kernel.org,suzuki.poulose@arm.com,robh@kernel.org,quic_jinlmao@quicinc.com,quic_hazha@quicinc.com,quic_bjorande@quicinc.com,o.rempel@pengutronix.de,mike.leach@linaro.org,matttbe@kernel.org,matt@ranostay.sg,kuba@kernel.org,krzk+dt@kernel.org,kees@kernel.org,jikos@kernel.org,geliang@kernel.org,davem@davemloft.net,conor+dt@kernel.org,james.clark@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dt-bindings-arm-update-james-clarks-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20240709213721.8A207C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dt-bindings: arm: opdate James Clark's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     dt-bindings-arm-update-james-clarks-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dt-bindings-arm-update-james-clarks-email-address.patch

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
Subject: dt-bindings: arm: opdate James Clark's email address
Date: Tue, 9 Jul 2024 11:25:11 +0100

My new address is james.clark@linaro.org

Link: https://lkml.kernel.org/r/20240709102512.31212-3-james.clark@linaro.org
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

 Documentation/devicetree/bindings/arm/arm,coresight-dummy-sink.yaml   |    2 +-
 Documentation/devicetree/bindings/arm/arm,coresight-dummy-source.yaml |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/arm/arm,coresight-dummy-sink.yaml~dt-bindings-arm-update-james-clarks-email-address
+++ a/Documentation/devicetree/bindings/arm/arm,coresight-dummy-sink.yaml
@@ -30,7 +30,7 @@ description: |
 maintainers:
   - Mike Leach <mike.leach@linaro.org>
   - Suzuki K Poulose <suzuki.poulose@arm.com>
-  - James Clark <james.clark@arm.com>
+  - James Clark <james.clark@linaro.org>
   - Mao Jinlong <quic_jinlmao@quicinc.com>
   - Hao Zhang <quic_hazha@quicinc.com>
 
--- a/Documentation/devicetree/bindings/arm/arm,coresight-dummy-source.yaml~dt-bindings-arm-update-james-clarks-email-address
+++ a/Documentation/devicetree/bindings/arm/arm,coresight-dummy-source.yaml
@@ -29,7 +29,7 @@ description: |
 maintainers:
   - Mike Leach <mike.leach@linaro.org>
   - Suzuki K Poulose <suzuki.poulose@arm.com>
-  - James Clark <james.clark@arm.com>
+  - James Clark <james.clark@linaro.org>
   - Mao Jinlong <quic_jinlmao@quicinc.com>
   - Hao Zhang <quic_hazha@quicinc.com>
 
_

Patches currently in -mm which might be from james.clark@linaro.org are

maintainers-mailmap-update-james-clarks-email-address.patch
dt-bindings-arm-update-james-clarks-email-address.patch

