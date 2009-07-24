From: akpm@linux-foundation.org
Subject: [to-be-updated] acpi-some-random-patch-whcih-apparently-fixes-something.patch removed from -mm tree
Date: Thu, 23 Jul 2009 18:43:49 -0700
Message-ID: <200907240143.n6O1hnGh010281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847AbZGXBo4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 21:44:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ming.m.lin@intel.com, Valdis.Kletnieks@vt.edu, hugh.dickins@tiscali.co.uk, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: some random patch whcih apparently fixes something
has been removed from the -mm tree.  Its filename was
     acpi-some-random-patch-whcih-apparently-fixes-something.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: some random patch whcih apparently fixes something
From: Lin Ming <ming.m.lin@intel.com>

Sigh.

Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/acpi/acpi_bus.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/acpi/acpi_bus.h~acpi-some-random-patch-whcih-apparently-fixes-something include/acpi/acpi_bus.h
--- a/include/acpi/acpi_bus.h~acpi-some-random-patch-whcih-apparently-fixes-something
+++ a/include/acpi/acpi_bus.h
@@ -186,8 +186,8 @@ struct acpi_device_pnp {
 
 #define acpi_device_bid(d)	((d)->pnp.bus_id)
 #define acpi_device_adr(d)	((d)->pnp.bus_address)
-#define acpi_device_hid(d)	((d)->pnp.hardware_id)
-#define acpi_device_uid(d)	((d)->pnp.unique_id)
+#define acpi_device_hid(d)	((d)->pnp.hardware_id ? (d)->pnp.hardware_id : "\0")
+#define acpi_device_uid(d)	((d)->pnp.unique_id ? (d)->pnp.unique_id : "\0")
 #define acpi_device_name(d)	((d)->pnp.device_name)
 #define acpi_device_class(d)	((d)->pnp.device_class)
 
_

Patches currently in -mm which might be from ming.m.lin@intel.com are

linux-next.patch
acpi-some-random-patch-whcih-apparently-fixes-something.patch
acpi-fix-null-bug-for-hid-uid-string.patch

