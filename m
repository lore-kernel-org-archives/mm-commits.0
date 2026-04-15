Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B17221FB1
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 09:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244605; cv=none; b=bEGUHz4LdBqcplvejc5e1m15XeZABVoooPj1f3uni+pvFtHtHzdbhUWsZfehoXZ9UtwsKRSB1gurQg3CDOxix/He7ML2SJuJWg69xvAv030RYxelDZ2NJY3C1t7Lsa2w85rRFxLF0AuqWr4zN4gbjUZRFqm/poOZVzLSrZcUbaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244605; c=relaxed/simple;
	bh=6QMS7L7ZPuwa629EeqXHz9rVF8WtfvrNi3/58wWSzTw=;
	h=Date:To:From:Subject:Message-Id; b=sWzJlwx/itOLlsTXeUse+ui0OlGNL4psui0QJ2h810WcbHQPs6GF9Im2wHGZoqXAPgluX24Om/tpc7KDKijZ4C4fbA17olYrM7mAmxhwM2zgo5MkuJ58Cri3QWY2qmC+lS4W0qLQKlctCNE1vZEM1IChHdueaCjBydhmOq9kbcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YvKi3ZYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YvKi3ZYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22E1C2BCB5;
	Wed, 15 Apr 2026 09:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244605;
	bh=6QMS7L7ZPuwa629EeqXHz9rVF8WtfvrNi3/58wWSzTw=;
	h=Date:To:From:Subject:From;
	b=YvKi3ZYRJ76TBwR96oF9DF1nZzx8fZ4Qs73MvWeZCrWjz88d9kDq0wq2Zvu5a/tz3
	 DhlXAYsKCGaSsmv5xJZAbTzurkhVLHWTS1EFH/YAvbLRvOu6qyt+Kg2K+W+QEF4KuN
	 o7JidfgFg1lA3JE95VCeFr9Kt1/WoXrlNreOC+sc=
Date: Wed, 15 Apr 2026 02:16:42 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,sean.anderson@seco.com,robh@kernel.org,krzysztof.kozlowski@oss.qualcomm.com,daniel.lezcano@kernel.org,conor+dt@kernel.org,sean.anderson@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] update-my-email-address.patch removed from -mm tree
Message-Id: <20260415091644.E22E1C2BCB5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: update Sean's email address
has been removed from the -mm tree.  Its filename was
     update-my-email-address.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sean Anderson <sean.anderson@linux.dev>
Subject: update Sean's email address
Date: Tue, 7 Apr 2026 12:47:21 -0400

Soon I will no longer be working at SECO.  Update the mailmap to redirect
to my linux.dev address which I still have access to.

Link: https://lkml.kernel.org/r/20260407164722.211610-1-sean.anderson@linux.dev
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: Sean Anderson <sean.anderson@seco.com>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap                                                    |    1 +
 Documentation/devicetree/bindings/timer/xlnx,xps-timer.yaml |    2 +-
 MAINTAINERS                                                 |    4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/devicetree/bindings/timer/xlnx,xps-timer.yaml~update-my-email-address
+++ a/Documentation/devicetree/bindings/timer/xlnx,xps-timer.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-sche
 title: Xilinx LogiCORE IP AXI Timer
 
 maintainers:
-  - Sean Anderson <sean.anderson@seco.com>
+  - Sean Anderson <sean.anderson@linux.dev>
 
 properties:
   compatible:
--- a/.mailmap~update-my-email-address
+++ a/.mailmap
@@ -740,6 +740,7 @@ Sathishkumar Muruganandam <quic_murugana
 Satya Priya <quic_skakitap@quicinc.com> <quic_c_skakit@quicinc.com> <skakit@codeaurora.org>
 S.Çağlar Onur <caglar@pardus.org.tr>
 Sayali Lokhande <quic_sayalil@quicinc.com> <sayalil@codeaurora.org>
+Sean Anderson <sean.anderson@linux.dev> <sean.anderson@seco.com>
 Sean Christopherson <seanjc@google.com> <sean.j.christopherson@intel.com>
 Sean Nyekjaer <sean@geanix.com> <sean.nyekjaer@prevas.dk>
 Sean Tranchetti <quic_stranche@quicinc.com> <stranche@codeaurora.org>
--- a/MAINTAINERS~update-my-email-address
+++ a/MAINTAINERS
@@ -10238,7 +10238,7 @@ F:	drivers/net/ethernet/freescale/dpaa
 
 FREESCALE QORIQ DPAA FMAN DRIVER
 M:	Madalin Bucur <madalin.bucur@nxp.com>
-R:	Sean Anderson <sean.anderson@seco.com>
+R:	Sean Anderson <sean.anderson@linux.dev>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/fsl,fman*.yaml
@@ -28899,7 +28899,7 @@ S:	Orphan
 F:	drivers/net/ethernet/xilinx/ll_temac*
 
 XILINX PWM DRIVER
-M:	Sean Anderson <sean.anderson@seco.com>
+M:	Sean Anderson <sean.anderson@linux.dev>
 S:	Maintained
 F:	drivers/pwm/pwm-xilinx.c
 F:	include/clocksource/timer-xilinx.h
_

Patches currently in -mm which might be from sean.anderson@linux.dev are


