From: akpm@linux-foundation.org
Subject: + dax-update-maintainers-entries-for-fs-dax.patch added to -mm
 tree
Date: Tue, 10 Jan 2017 14:51:30 -0800
Message-ID: <58756572.ekGmhVFoJM3ZywjO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47986 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756039AbdAJWvb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2017 17:51:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dave.jiang@intel.com, david@fromorbit.com, jack@suse.cz, mawilcox@microsoft.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: update MAINTAINERS entries for FS DAX
has been added to the -mm tree.  Its filename is
     dax-update-maintainers-entries-for-fs-dax.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-update-maintainers-entries-for-fs-dax.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-update-maintainers-entries-for-fs-dax.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: update MAINTAINERS entries for FS DAX

Add the new include/trace/events/fs_dax.h tracepoint header, the existing
include/linux/dax.h header, update Matthew's email address and add myself
as a maintainer for filesystem DAX.

Link: http://lkml.kernel.org/r/1484085142-2297-4-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~dax-update-maintainers-entries-for-fs-dax MAINTAINERS
--- a/MAINTAINERS~dax-update-maintainers-entries-for-fs-dax
+++ a/MAINTAINERS
@@ -3910,10 +3910,13 @@ S:	Maintained
 F:	drivers/i2c/busses/i2c-diolan-u2c.c
 
 DIRECT ACCESS (DAX)
-M:	Matthew Wilcox <willy@linux.intel.com>
+M:	Matthew Wilcox <mawilcox@microsoft.com>
+M:	Ross Zwisler <ross.zwisler@linux.intel.com>
 L:	linux-fsdevel@vger.kernel.org
 S:	Supported
 F:	fs/dax.c
+F:	include/linux/dax.h
+F:	include/trace/events/fs_dax.h
 
 DIRECTORY NOTIFICATION (DNOTIFY)
 M:	Eric Paris <eparis@parisplace.org>
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-deadlock-with-dax-4k-holes.patch
mm-add-follow_pte_pmd.patch
dax-wrprotect-pmd_t-in-dax_mapping_entry_mkclean.patch
dax-fix-build-warnings-with-fs_dax-and-fs_iomap.patch
tracing-add-__print_flags_u64.patch
dax-add-tracepoint-infrastructure-pmd-tracing.patch
dax-update-maintainers-entries-for-fs-dax.patch
dax-add-tracepoints-to-dax_pmd_load_hole.patch
dax-add-tracepoints-to-dax_pmd_insert_mapping.patch

