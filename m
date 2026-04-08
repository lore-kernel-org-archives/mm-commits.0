Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF5333122A
	for <mm-commits@vger.kernel.org>; Wed,  8 Apr 2026 16:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775664872; cv=none; b=DtlUjeBnBk8x2MdRHZCavjAOm8Xp3fDMpz18SjX9nw90r47SBHB1zymHEsTMIiRnJIcUXhBhaXKvA87B2PMcGmEepucgUdn8OUoiYvmHiyuzZBGa7VPETnmwT5BIyn2Uu2E2bk8ZHt+IWHR9cMyXrAf25khYdSSwESm82tfC+kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775664872; c=relaxed/simple;
	bh=b+271bunSF0kVoOxlt198SSPNZhfUrv1YxbJ46Mrpco=;
	h=Date:To:From:Subject:Message-Id; b=a61PwMltDNC/eUW7a1lUrXOruYtZbJgIFreIqiRPCRXUqsLghtMt4/fqwNOUV74/m3MdMma91hWuFcGxB2VrZ6Dw6x29kBYWo85Na27hs9S4VoVRhwOpqeznw69bnhOMdEwwNmXrpXd7rWl2wa9FTM1/pE149T1SMnQT4o6vD+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Je6bCz9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Je6bCz9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B02C19425;
	Wed,  8 Apr 2026 16:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775664871;
	bh=b+271bunSF0kVoOxlt198SSPNZhfUrv1YxbJ46Mrpco=;
	h=Date:To:From:Subject:From;
	b=Je6bCz9w6wWmibw7nOp2thQYNdmHRKxkRm92o19M+EJCmm1dYuXprJR/Sr4yHtuSo
	 R6IEZAhzzbHchVk5wV7Z0WAncFhiSzM7p7/m8ED2QC5Azl4YOcWan1aU0fukgJF2Eg
	 kLfC2WK/UjMFRX9m+m68jwCWVcPy0JE78gxxIKwo=
Date: Wed, 08 Apr 2026 09:14:31 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,sean.anderson@seco.com,robh@kernel.org,krzysztof.kozlowski@oss.qualcomm.com,daniel.lezcano@kernel.org,conor+dt@kernel.org,sean.anderson@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + update-my-email-address.patch added to mm-nonmm-unstable branch
Message-Id: <20260408161431.C2B02C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Update Sean's email address
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     update-my-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/update-my-email-address.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sean Anderson <sean.anderson@linux.dev>
Subject: Update Sean's email address
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
@@ -741,6 +741,7 @@ Sathishkumar Muruganandam <quic_murugana
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
@@ -28917,7 +28917,7 @@ S:	Orphan
 F:	drivers/net/ethernet/xilinx/ll_temac*
 
 XILINX PWM DRIVER
-M:	Sean Anderson <sean.anderson@seco.com>
+M:	Sean Anderson <sean.anderson@linux.dev>
 S:	Maintained
 F:	drivers/pwm/pwm-xilinx.c
 F:	include/clocksource/timer-xilinx.h
_

Patches currently in -mm which might be from sean.anderson@linux.dev are

update-my-email-address.patch

