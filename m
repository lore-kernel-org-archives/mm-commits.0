Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5CF149C40
	for <mm-commits@vger.kernel.org>; Fri, 26 Jul 2024 20:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722026288; cv=none; b=pRxtxHWmkUzyNAh4QWv8zLEvC5ZqbQq2HyWlsGx7yrSpJNAMFuzi0EQWDrUaVCH46sRj89aAcaA5Ve0y9Xugs3nuRVXBoRV7rz6IlQGOU+PgO9KUqhI4er82KLnhsOkmaMd9taoCWz4TDXU0ZcoMBZinDa924duFQ42YWMy5aGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722026288; c=relaxed/simple;
	bh=/EC4vU9+VSPK2/eg5DGR/CvH+04HKdVdmVThP+sD5Cg=;
	h=Date:To:From:Subject:Message-Id; b=MzzAklt/mqxHHtE67XGN/hXLAX87WXFo4H+IY7/2jxYcdgsMzaC9YnggUQCSUfRj6zLM7B0FIk45MXAyrO81Ju6CQaK/GLz4ZC7Nxni+w1yOSI7SkuAO+iP0mwmUm8fguYbGpm1oCeI4qJBUl2PEKGBGPTvLOpwtOuLxM1xXkHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CRqXxhh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CRqXxhh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7397BC32782;
	Fri, 26 Jul 2024 20:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722026287;
	bh=/EC4vU9+VSPK2/eg5DGR/CvH+04HKdVdmVThP+sD5Cg=;
	h=Date:To:From:Subject:From;
	b=CRqXxhh0kqwwvtrgrOgKdiBlR0sWASa9oKjJb5ut2ybRmi5zhaSSVpuHy2a9r8qEP
	 O9IPkw80MEbd2PKIknVAj8q9dofmegED2z9UpKPx3ZtFxq1MS/oOaw1L3WziRCeJDa
	 Il5LZf9hwoJn2sgTHrL8HfiN40yb28FDSN6/7E50=
Date: Fri, 26 Jul 2024 13:38:06 -0700
To: mm-commits@vger.kernel.org,suzuki.poulose@arm.com,robh@kernel.org,quic_jinlmao@quicinc.com,quic_hazha@quicinc.com,quic_bjorande@quicinc.com,o.rempel@pengutronix.de,mike.leach@linaro.org,matttbe@kernel.org,matt@ranostay.sg,kuba@kernel.org,krzk+dt@kernel.org,kees@kernel.org,jikos@kernel.org,geliang@kernel.org,davem@davemloft.net,conor+dt@kernel.org,james.clark@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] dt-bindings-arm-update-james-clarks-email-address.patch removed from -mm tree
Message-Id: <20240726203807.7397BC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dt-bindings: arm: opdate James Clark's email address
has been removed from the -mm tree.  Its filename was
     dt-bindings-arm-update-james-clarks-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


