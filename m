From: akpm@linux-foundation.org
Subject: + docbook-fix-rapidio-source-files.patch added to -mm tree
Date: Sun, 02 Mar 2008 23:23:33 -0800
Message-ID: <200803030723.m237NX9q004385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802AbYCCHYW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 02:24:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     docbook: fix rapidio source files
has been added to the -mm tree.  Its filename is
     docbook-fix-rapidio-source-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbook: fix rapidio source files
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook problems in rapidio source files.  These cause the generated
docbook to be incorrect.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-driver.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/rapidio/rio-driver.c~docbook-fix-rapidio-source-files drivers/rapidio/rio-driver.c
--- a/drivers/rapidio/rio-driver.c~docbook-fix-rapidio-source-files
+++ a/drivers/rapidio/rio-driver.c
@@ -78,8 +78,7 @@ void rio_dev_put(struct rio_dev *rdev)
 }
 
 /**
- *  rio_device_probe - Tell if a RIO device structure has a matching RIO
- *                     device id structure
+ *  rio_device_probe - Tell if a RIO device structure has a matching RIO device id structure
  *  @id: the RIO device id structure to match against
  *  @dev: the RIO device structure to match against
  *
@@ -137,7 +136,7 @@ static int rio_device_remove(struct devi
  *  rio_register_driver - register a new RIO driver
  *  @rdrv: the RIO driver structure to register
  *
- *  Adds a &struct rio_driver to the list of registered drivers
+ *  Adds a &struct rio_driver to the list of registered drivers.
  *  Returns a negative value on error, otherwise 0. If no error
  *  occurred, the driver remains registered even if no device
  *  was claimed during registration.
@@ -167,8 +166,7 @@ void rio_unregister_driver(struct rio_dr
 }
 
 /**
- *  rio_match_bus - Tell if a RIO device structure has a matching RIO
- *                  driver device id structure
+ *  rio_match_bus - Tell if a RIO device structure has a matching RIO driver device id structure
  *  @dev: the standard device structure to match against
  *  @drv: the standard driver structure containing the ids to match against
  *
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-unionfs.patch
wireless-rt2x00-fix-driver-menu-indenting.patch
kprobes-move-kprobe-examples-to-samples.patch
x86-visws-fix-printk-format-warnings.patch
apanel-fix-kconfig-dependencies.patch
let-log_buf_shift-default-to-17.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
profile-likely-unlikely-macros.patch
docbook-fix-filesystemstmpl-source-files.patch
docbook-fix-rapidio-source-files.patch
docbook-fix-scsi-source-file.patch
docbook-fix-kernel-api-source-files.patch
docbook-fix-fusion-source-files.patch

