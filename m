From: akpm@linux-foundation.org
Subject: + frv-update-the-frv-arch-maintainer-record-to-get-a-hit-on.patch added to -mm tree
Date: Tue, 10 Apr 2007 16:15:07 -0700
Message-ID: <200704102315.l3ANF7wg022678@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51278 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161062AbXDJXPT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 19:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     FRV: Update the FRV arch MAINTAINER record to get a hit on "grep -i frv"
has been added to the -mm tree.  Its filename is
     frv-update-the-frv-arch-maintainer-record-to-get-a-hit-on.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: FRV: Update the FRV arch MAINTAINER record to get a hit on "grep -i frv"
From: David Howells <dhowells@redhat.com>

Update the FRV arch MAINTAINER record to get a hit on "grep -i frv".  Whilst
FR-V is technically correct, it's normally thought of as FRV.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~frv-update-the-frv-arch-maintainer-record-to-get-a-hit-on MAINTAINERS
--- a/MAINTAINERS~frv-update-the-frv-arch-maintainer-record-to-get-a-hit-on
+++ a/MAINTAINERS
@@ -1404,7 +1404,7 @@ M:	hch@infradead.org
 W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
 S:	Maintained
 
-FUJITSU FR-V PORT
+FUJITSU FR-V (FRV) PORT
 P:	David Howells
 M:	dhowells@redhat.com
 S:	Maintained
_

Patches currently in -mm which might be from dhowells@redhat.com are

frv-update-the-frv-arch-maintainer-record-to-get-a-hit-on.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
romfs-printk-format-warnings.patch
git-net.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
kill-net-rxrpc-rxrpc_symsc.patch
use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
use-slab_panic-flag-cleanup.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
workqueue-kill-noautorel-works.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
mutex-subsystem-synchro-test-module.patch
