Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F3C2D94BA
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 02:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779415627; cv=none; b=k41tPrmn9erzkTPIJXHutA7VN9QWmPdECWj0mUECLhTGoL6HZEWOoVVq/yYoyoC/v/qwxLfQe0sb0IpIU6rm4sCSRgY/WDIyDpijdla8Lu9iu/KFKVdJGFPVWV9cgjaBktmtv6N9HAy5Zb3ZSpeV0vtO/bHdgzdOA6PFgCzGlZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779415627; c=relaxed/simple;
	bh=yg/oR/l98ZgThYhbSNNirKYICc8oPir4BF3MrDJVlXo=;
	h=Date:To:From:Subject:Message-Id; b=dR6kjFTkMIyloEN0h2QVw+Ir+a9GnxIxx7dUPGOiNrLNLEPZgWgR5e4WMwbY92W+VJhKeJGghYpolP72tHrNy6IudyLz3lxaxUTdR9vpEs9YJVxbwe1Fvj/LTFxLFHhSameWpbsnwai3q3gW4WY3Z45D9PVQ7gK+1KnMNWn/ucc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KpZZTmql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KpZZTmql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6C71F000E9;
	Fri, 22 May 2026 02:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779415625;
	bh=P8JA/Ne1yW3X0hkUKicKN5IpkVoq/WLQ7BzyMy3hTWs=;
	h=Date:To:From:Subject;
	b=KpZZTmqlI0IKwcvGt2RTJb//6/O6bJGOdO66m29jWjTUBH2s4GtvzraPARgPAlWty
	 NTDVBY1jzlmtOCUjisb2TTta6wqdUr9xh3pUdz9lAYPm33MphcaL/7ghJ+jPZIfGKE
	 XCplB0plDYiDspMvqTWpsBhQzf6Pqgho/4CyRhv0=
Date: Thu, 21 May 2026 19:07:05 -0700
To: mm-commits@vger.kernel.org,ehristev@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-mailmap-change-email-for-eugen-hristev.patch removed from -mm tree
Message-Id: <20260522020705.AC6C71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS, mailmap: change email for Eugen Hristev
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-change-email-for-eugen-hristev.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eugen Hristev <ehristev@kernel.org>
Subject: MAINTAINERS, mailmap: change email for Eugen Hristev
Date: Sat, 25 Apr 2026 16:06:48 +0300

Replace old bouncing emails with ehristev@kernel.org

Link: https://lore.kernel.org/20260425-eh-mailmap-v1-1-58788d401eef@kernel.org
Signed-off-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    5 +++--
 MAINTAINERS |   12 ++++++------
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/.mailmap~maintainers-mailmap-change-email-for-eugen-hristev
+++ a/.mailmap
@@ -263,8 +263,9 @@ Enric Balletbo i Serra <eballetbo@kernel
 Enric Balletbo i Serra <eballetbo@kernel.org> <eballetbo@iseebcn.com>
 Erik Kaneda <erik.kaneda@intel.com> <erik.schmauss@intel.com>
 Ethan Carter Edwards <ethan@ethancedwards.com> Ethan Edwards <ethancarteredwards@gmail.com>
-Eugen Hristev <eugen.hristev@linaro.org> <eugen.hristev@microchip.com>
-Eugen Hristev <eugen.hristev@linaro.org> <eugen.hristev@collabora.com>
+Eugen Hristev <ehristev@kernel.org> <eugen.hristev@microchip.com>
+Eugen Hristev <ehristev@kernel.org> <eugen.hristev@linaro.org>
+Eugen Hristev <ehristev@kernel.org> <eugen.hristev@collabora.com>
 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
 Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> <ezequiel@collabora.com>
 Faith Ekstrand <faith.ekstrand@collabora.com> <jason@jlekstrand.net>
--- a/MAINTAINERS~maintainers-mailmap-change-email-for-eugen-hristev
+++ a/MAINTAINERS
@@ -10832,7 +10832,7 @@ F:	include/linux/generic-radix-tree.h
 F:	lib/generic-radix-tree.c
 
 GENERIC RESISTIVE TOUCHSCREEN ADC DRIVER
-M:	Eugen Hristev <eugen.hristev@microchip.com>
+M:	Eugen Hristev <ehristev@kernel.org>
 L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/input/touchscreen/resistive-adc-touch.c
@@ -17343,7 +17343,7 @@ F:	Documentation/devicetree/bindings/sou
 F:	sound/soc/atmel
 
 MICROCHIP CSI2DC DRIVER
-M:	Eugen Hristev <eugen.hristev@microchip.com>
+M:	Eugen Hristev <ehristev@kernel.org>
 L:	linux-media@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/media/microchip,csi2dc.yaml
@@ -17370,7 +17370,7 @@ F:	drivers/i2c/busses/i2c-at91-*.c
 F:	drivers/i2c/busses/i2c-at91.h
 
 MICROCHIP ISC DRIVER
-M:	Eugen Hristev <eugen.hristev@microchip.com>
+M:	Eugen Hristev <ehristev@kernel.org>
 L:	linux-media@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/media/atmel,isc.yaml
@@ -17382,7 +17382,7 @@ F:	drivers/staging/media/deprecated/atme
 F:	include/linux/atmel-isc-media.h
 
 MICROCHIP ISI DRIVER
-M:	Eugen Hristev <eugen.hristev@microchip.com>
+M:	Eugen Hristev <ehristev@kernel.org>
 L:	linux-media@vger.kernel.org
 S:	Supported
 F:	drivers/media/platform/atmel/atmel-isi.c
@@ -17572,7 +17572,7 @@ F:	Documentation/devicetree/bindings/dis
 F:	drivers/gpu/drm/bridge/microchip-lvds.c
 
 MICROCHIP SAMA5D2-COMPATIBLE ADC DRIVER
-M:	Eugen Hristev <eugen.hristev@microchip.com>
+M:	Eugen Hristev <ehristev@kernel.org>
 L:	linux-iio@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/iio/adc/atmel,sama5d2-adc.yaml
@@ -24123,7 +24123,7 @@ F:	drivers/mmc/host/sdhci*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) MICROCHIP DRIVER
 M:	Aubin Constans <aubin.constans@microchip.com>
-R:	Eugen Hristev <eugen.hristev@collabora.com>
+R:	Eugen Hristev <ehristev@kernel.org>
 L:	linux-mmc@vger.kernel.org
 S:	Supported
 F:	drivers/mmc/host/sdhci-of-at91.c
_

Patches currently in -mm which might be from ehristev@kernel.org are


