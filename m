From: akpm@linux-foundation.org
Subject: [merged] thermal-sysfs-apitxt-document-passive-attribute-for-thermal-zones.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:54:51 -0800
Message-ID: <200911091954.nA9Jsp3w022467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753898AbZKITzR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:55:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, lenb@kernel.org, mjg59@srcf.ucam.org, rui.zhang@intel.com, sujith.thomas@intel.com, mm-commits@vger.kernel.org


The patch titled
     thermal: sysfs-api.txt - document passive attribute for thermal zones
has been removed from the -mm tree.  Its filename was
     thermal-sysfs-apitxt-document-passive-attribute-for-thermal-zones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thermal: sysfs-api.txt - document passive attribute for thermal zones
From: Frans Pop <elendil@planet.nl>

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/thermal/sysfs-api.txt~thermal-sysfs-apitxt-document-passive-attribute-for-thermal-zones Documentation/thermal/sysfs-api.txt
--- a/Documentation/thermal/sysfs-api.txt~thermal-sysfs-apitxt-document-passive-attribute-for-thermal-zones
+++ a/Documentation/thermal/sysfs-api.txt
@@ -199,6 +199,15 @@ cdev[0-*]_trip_point
 	point.
 	RO, Optional
 
+passive
+	Attribute is only present for zones in which the passive cooling
+	policy is not supported by native thermal driver. Default is zero
+	and can be set to a temperature (in millidegrees) to enable a
+	passive trip point for the zone. Activation is done by polling with
+	an interval of 1 second.
+	Unit: millidegrees Celsius
+	RW, Optional
+
 *****************************
 * Cooling device attributes *
 *****************************
_

Patches currently in -mm which might be from elendil@planet.nl are

origin.patch
linux-next.patch
acpi-thermal-display-forced-passive-trip-points-in-proc.patch
thermal-add-sanity-check-for-the-passive-attribute.patch
thermal-only-set-passive_delay-for-forced_passive-cooling.patch
thermal-disable-polling-if-passive_delay-and-polling_delay-are-both-unset.patch

