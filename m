From: akpm@linux-foundation.org
Subject: [withdrawn]
 rtc-ds1307-add-device-tree-bindings-documentation.patch removed from -mm
 tree
Date: Fri, 28 Nov 2014 08:09:52 -0800
Message-ID: <54789e50.pYACq9Od6qe7TLzg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaK1QJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Nov 2014 11:09:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomas@novotny.cz, a.zummo@towertech.it, grant.likely@linaro.org, robh+dt@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: ds1307: add device tree bindings documentation
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-add-device-tree-bindings-documentation.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Tomas Novotny <tomas@novotny.cz>
Subject: rtc: ds1307: add device tree bindings documentation

Signed-off-by: Tomas Novotny <tomas@novotny.cz>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/maxim,ds1307.txt |   23 ++++++++++
 1 file changed, 23 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/maxim,ds1307.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/maxim,ds1307.txt
@@ -0,0 +1,23 @@
+* Maxim (Dallas) DS1307 and compatible Real Time Clock
+
+For example, compatible chips are Maxim DS1337, Microchip MCP794xx,
+STMicroelectronics M41T00 and Epson RX-8025.
+
+Required properties:
+- compatible: For example "maxim,ds1307" (see rtc-ds1307.c driver for a full
+  list).
+- reg: i2c address
+
+Example for DS1307:
+
+ds1307: rtc@68 {
+	compatible = "maxim,ds1307";
+	reg = <0x68>;
+};
+
+Example for MCP79401:
+
+mcp7940x: rtc@6f {
+	compatible = "microchip,mcp7940x";
+	reg = <0x6f>;
+};
_

Patches currently in -mm which might be from tomas@novotny.cz are

rtc-ds1307-add-support-for-mcp7940x-chips.patch
of-add-vendor-prefix-for-pericom-technology.patch
rtc-ds1307-add-device-tree-support.patch

