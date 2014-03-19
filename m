From: akpm@linux-foundation.org
Subject: [to-be-updated]
 documentation-bindings-document-pmic8921-8058-rtc.patch removed from -mm
 tree
Date: Wed, 19 Mar 2014 16:14:48 -0700
Message-ID: <532a24e8.B+o3adjofZZVRUpR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759316AbaCSXOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Mar 2014 19:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sboyd@codeaurora.org, a.zummo@towertech.it, joshc@codeaurora.org

Subject: [to-be-updated] documentation-bindings-document-pmic8921-8058-rtc.patch removed from -mm tree
To: joshc@codeaurora.org,a.zummo@towertech.it,sboyd@codeaurora.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 19 Mar 2014 16:14:48 -0700


The patch titled
     Subject: documentation: bindings: document PMIC8921/8058 RTC
has been removed from the -mm tree.  Its filename was
     documentation-bindings-document-pmic8921-8058-rtc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Josh Cartwright <joshc@codeaurora.org>
Subject: documentation: bindings: document PMIC8921/8058 RTC

This RTC is found on the Qualcomm 8921 and 8058 PMICs.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt |   21 ++++++++++
 1 file changed, 21 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
@@ -0,0 +1,21 @@
+* Real-Time Clock for Qualcomm 8058/8921 PMICs
+
+Required properties:
+- compatible: should be one of the following.
+    * "qcom,pm8058-rtc"
+    * "qcom,pm8921-rtc"
+- reg: base address of the register region
+- interrupts: interrupt list for the RTC, must contain a single interrupt
+              specifier for the alarm interrupt
+
+Optional properties:
+- allow-set-time: indicates that the setting of RTC time is allowed by
+                  the host CPU
+
+Example:
+
+	rtc@11d {
+		compatible = "qcom,pm8921-rtc";
+		reg = <0x11d>;
+		interrupts = <0x27 0>;
+	};
_

Patches currently in -mm which might be from joshc@codeaurora.org are

rtc-pm8xxx-fixup-checkpatch-style-issues.patch
rtc-pm8xxx-use-regmap-api-for-register-accesses.patch
rtc-pm8xxx-use-devm_request_any_context_irq.patch
rtc-pm8xxx-add-support-for-devicetree.patch
rtc-pm8xxx-move-device_init_wakeup-before-rtc_register.patch
linux-next.patch

