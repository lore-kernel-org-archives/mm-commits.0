Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0818C28A1E7
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849751; cv=none; b=BSyqFVfSvPZ0UYg9SyAtctjjwSWO3M0ripHUj1KrgEqFqkYejQ8xWmMBYdS3kE44kQ+ck0N1yyQ57IEYa+yIn1AFR2tkNDQGQ6HdpPnOOO1ZmBZ+XasnCMb8Ue4iPFp/QcOlhoptDhsL8cUks0FYdW+KxXeJx3QWI3Vy9kPUz1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849751; c=relaxed/simple;
	bh=BruuSd8U0ZwA4xGNmCW7HRqs9Uzr7LpuJPSPJ6gMSjs=;
	h=Date:To:From:Subject:Message-Id; b=OrEb2UUadYNk1X3JviSh6/6UAm0h0Mz+jYPwIWEtHCWCfTR1QYgKdEnOUtv8r2Vx5Tif8w3pbCNtYYS9vS7JVdi9pByHWpXIqqsYiAK3u9J8YMkbY8bLjH3Aico7qR/4KwOdIf/jdh8mX4EK8hU46WfBUXn0bSFxNP79IHlXIAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pkxjmWWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pkxjmWWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C698AC4CEE4;
	Wed, 21 May 2025 17:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849750;
	bh=BruuSd8U0ZwA4xGNmCW7HRqs9Uzr7LpuJPSPJ6gMSjs=;
	h=Date:To:From:Subject:From;
	b=pkxjmWWtlVQ/YJlDpuY9VR9OuleinsLajRP+OS89Lg4d2Cauw6DitMVKdwxF/nrYZ
	 iRKA7iquVjsRD9IMDtJnekLBuSz4px67iKYy74FwPCQeGZaj3zEy8BKQEz0sM8O93x
	 Lswv8l1/Yah35JmJ2QUsXtaiB6I2O2jn9ojZH+S4=
Date: Wed, 21 May 2025 10:49:10 -0700
To: mm-commits@vger.kernel.org,krzk@kernel.org,casey.connolly@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-and-consolidate-casey-connollys-name-and-email.patch removed from -mm tree
Message-Id: <20250521174910.C698AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update and consolidate Casey Connolly's name and email
has been removed from the -mm tree.  Its filename was
     mailmap-update-and-consolidate-casey-connollys-name-and-email.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Casey Connolly <casey.connolly@linaro.org>
Subject: mailmap: update and consolidate Casey Connolly's name and email
Date: Sat, 17 May 2025 23:32:38 +0100

I've used several email addresses and a previous name to contribute. 
Consolidate all of these to my primary email and update my name.

Link: https://lkml.kernel.org/r/20250517223237.15647-2-casey.connolly@linaro.org
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap                                                                 |    3 +++
 Documentation/devicetree/bindings/display/panel/lg,sw43408.yaml          |    2 +-
 Documentation/devicetree/bindings/iio/adc/qcom,spmi-rradc.yaml           |    2 +-
 Documentation/devicetree/bindings/power/supply/qcom,pmi8998-charger.yaml |    2 +-
 MAINTAINERS                                                              |    2 +-
 arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts                         |    2 +-
 arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts                        |    2 +-
 drivers/gpu/drm/panel/panel-samsung-sofef00.c                            |    4 ++--
 drivers/iio/adc/qcom-spmi-rradc.c                                        |    4 ++--
 drivers/power/supply/qcom_pmi8998_charger.c                              |    4 ++--
 include/soc/qcom/qcom-spmi-pmic.h                                        |    2 +-
 11 files changed, 16 insertions(+), 13 deletions(-)

--- a/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts~mailmap-update-and-consolidate-casey-connollys-name-and-email
+++ a/arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dts
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause
 /*
  * Copyright (c) 2023, Luca Weiss <luca.weiss@fairphone.com>
- * Copyright (c) 2024, Caleb Connolly <caleb@postmarketos.org>
+ * Copyright (c) 2024, Casey Connolly <casey.connolly@linaro.org>
  */
 
 /dts-v1/;
--- a/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts~mailmap-update-and-consolidate-casey-connollys-name-and-email
+++ a/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (c) 2022, Alexander Martinz <amartinz@shiftphones.com>
- * Copyright (c) 2022, Caleb Connolly <caleb@connolly.tech>
+ * Copyright (c) 2022, Casey Connolly <casey.connolly@linaro.org>
  * Copyright (c) 2022, Dylan Van Assche <me@dylanvanassche.be>
  */
 
--- a/Documentation/devicetree/bindings/display/panel/lg,sw43408.yaml~mailmap-update-and-consolidate-casey-connollys-name-and-email
+++ a/Documentation/devicetree/bindings/display/panel/lg,sw43408.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-sche
 title: LG SW43408 1080x2160 DSI panel
 
 maintainers:
-  - Caleb Connolly <caleb.connolly@linaro.org>
+  - Casey Connolly <casey.connolly@linaro.org>
 
 description:
   This panel is used on the Pixel 3, it is a 60hz OLED panel which
--- a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-rradc.yaml~mailmap-update-and-consolidate-casey-connollys-name-and-email
+++ a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-rradc.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-sche
 title: Qualcomm's SPMI PMIC Round Robin ADC
 
 maintainers:
-  - Caleb Connolly <caleb.connolly@linaro.org>
+  - Casey Connolly <casey.connolly@linaro.org>
 
 description: |
   The Qualcomm SPMI Round Robin ADC (RRADC) provides interface to clients to
--- a/Documentation/devicetree/bindings/power/supply/qcom,pmi8998-charger.yaml~mailmap-update-and-consolidate-casey-connollys-name-and-email
+++ a/Documentation/devicetree/bindings/power/supply/qcom,pmi8998-charger.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-sche
 title: Qualcomm PMI8998/PM660 Switch-Mode Battery Charger "2"
 
 maintainers:
-  - Caleb Connolly <caleb.connolly@linaro.org>
+  - Casey Connolly <casey.connolly@linaro.org>
 
 properties:
   compatible:
--- a/drivers/gpu/drm/panel/panel-samsung-sofef00.c~mailmap-update-and-consolidate-casey-connollys-name-and-email
+++ a/drivers/gpu/drm/panel/panel-samsung-sofef00.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2020 Caleb Connolly <caleb@connolly.tech>
+/* Copyright (c) 2020 Casey Connolly <casey.connolly@linaro.org>
  * Generated with linux-mdss-dsi-panel-driver-generator from vendor device tree:
  * Copyright (c) 2020, The Linux Foundation. All rights reserved.
  */
@@ -318,6 +318,6 @@ static struct mipi_dsi_driver sofef00_pa
 
 module_mipi_dsi_driver(sofef00_panel_driver);
 
-MODULE_AUTHOR("Caleb Connolly <caleb@connolly.tech>");
+MODULE_AUTHOR("Casey Connolly <casey.connolly@linaro.org>");
 MODULE_DESCRIPTION("DRM driver for Samsung AMOLED DSI panels found in OnePlus 6/6T phones");
 MODULE_LICENSE("GPL v2");
--- a/drivers/iio/adc/qcom-spmi-rradc.c~mailmap-update-and-consolidate-casey-connollys-name-and-email
+++ a/drivers/iio/adc/qcom-spmi-rradc.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) 2016-2017, 2019, The Linux Foundation. All rights reserved.
  * Copyright (c) 2022 Linaro Limited.
- *  Author: Caleb Connolly <caleb.connolly@linaro.org>
+ *  Author: Casey Connolly <casey.connolly@linaro.org>
  *
  * This driver is for the Round Robin ADC found in the pmi8998 and pm660 PMICs.
  */
@@ -1016,5 +1016,5 @@ static struct platform_driver rradc_driv
 module_platform_driver(rradc_driver);
 
 MODULE_DESCRIPTION("QCOM SPMI PMIC RR ADC driver");
-MODULE_AUTHOR("Caleb Connolly <caleb.connolly@linaro.org>");
+MODULE_AUTHOR("Casey Connolly <casey.connolly@linaro.org>");
 MODULE_LICENSE("GPL");
--- a/drivers/power/supply/qcom_pmi8998_charger.c~mailmap-update-and-consolidate-casey-connollys-name-and-email
+++ a/drivers/power/supply/qcom_pmi8998_charger.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) 2016-2019 The Linux Foundation. All rights reserved.
  * Copyright (c) 2023, Linaro Ltd.
- * Author: Caleb Connolly <caleb.connolly@linaro.org>
+ * Author: Casey Connolly <casey.connolly@linaro.org>
  *
  * This driver is for the switch-mode battery charger and boost
  * hardware found in pmi8998 and related PMICs.
@@ -1045,6 +1045,6 @@ static struct platform_driver qcom_spmi_
 
 module_platform_driver(qcom_spmi_smb2);
 
-MODULE_AUTHOR("Caleb Connolly <caleb.connolly@linaro.org>");
+MODULE_AUTHOR("Casey Connolly <casey.connolly@linaro.org>");
 MODULE_DESCRIPTION("Qualcomm SMB2 Charger Driver");
 MODULE_LICENSE("GPL");
--- a/include/soc/qcom/qcom-spmi-pmic.h~mailmap-update-and-consolidate-casey-connollys-name-and-email
+++ a/include/soc/qcom/qcom-spmi-pmic.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /* Copyright (c) 2022 Linaro. All rights reserved.
- * Author: Caleb Connolly <caleb.connolly@linaro.org>
+ * Author: Casey Connolly <casey.connolly@linaro.org>
  */
 
 #ifndef __QCOM_SPMI_PMIC_H__
--- a/.mailmap~mailmap-update-and-consolidate-casey-connollys-name-and-email
+++ a/.mailmap
@@ -154,6 +154,9 @@ Brian King <brking@us.ibm.com>
 Brian Silverman <bsilver16384@gmail.com> <brian.silverman@bluerivertech.com>
 Bryan Tan <bryan-bt.tan@broadcom.com> <bryantan@vmware.com>
 Cai Huoqing <cai.huoqing@linux.dev> <caihuoqing@baidu.com>
+Casey Connolly <casey.connolly@linaro.org> <caleb.connolly@linaro.org>
+Casey Connolly <casey.connolly@linaro.org> <caleb@connolly.tech>
+Casey Connolly <casey.connolly@linaro.org> <caleb@postmarketos.org>
 Can Guo <quic_cang@quicinc.com> <cang@codeaurora.org>
 Carl Huang <quic_cjhuang@quicinc.com> <cjhuang@codeaurora.org>
 Carlos Bilbao <carlos.bilbao@kernel.org> <carlos.bilbao@amd.com>
--- a/MAINTAINERS~mailmap-update-and-consolidate-casey-connollys-name-and-email
+++ a/MAINTAINERS
@@ -7460,7 +7460,7 @@ F:	drivers/gpu/drm/panel/panel-jadard-jd
 
 DRM DRIVER FOR LG SW43408 PANELS
 M:	Sumit Semwal <sumit.semwal@linaro.org>
-M:	Caleb Connolly <caleb.connolly@linaro.org>
+M:	Casey Connolly <casey.connolly@linaro.org>
 S:	Maintained
 T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
 F:	Documentation/devicetree/bindings/display/panel/lg,sw43408.yaml
_

Patches currently in -mm which might be from casey.connolly@linaro.org are


