From: akpm@linux-foundation.org
Subject: [merged] rtc-digicolor-document-device-tree-binding.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:58 -0700
Message-ID: <553550e6.aLwDeiKJ/9nmueLN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbbDTTLh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baruch@tkos.co.il, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: digicolor: document device tree binding
has been removed from the -mm tree.  Its filename was
     rtc-digicolor-document-device-tree-binding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baruch Siach <baruch@tkos.co.il>
Subject: rtc: digicolor: document device tree binding

Add a device tree binding documentation to the Real Time Clock hardware
block on the Conexant CX92755 SoC.  The CX92755 is from the Digicolor SoCs
series.  Other SoCs in that series may share the same hardware block.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/digicolor-rtc.txt |   17 ++++++++++
 1 file changed, 17 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/digicolor-rtc.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/digicolor-rtc.txt
@@ -0,0 +1,17 @@
+Conexant Digicolor Real Time Clock controller
+
+This binding currently supports the CX92755 SoC.
+
+Required properties:
+- compatible: should be "cnxt,cx92755-rtc"
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: rtc alarm interrupt
+
+Example:
+
+	rtc@f0000c30 {
+		compatible = "cnxt,cx92755-rtc";
+		reg = <0xf0000c30 0x18>;
+		interrupts = <25>;
+	};
_

Patches currently in -mm which might be from baruch@tkos.co.il are

origin.patch
linux-next.patch

