Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 942E8E936E3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244863AbjJDUYa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244992AbjJDUXY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5055C111
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBC0C433CA;
        Wed,  4 Oct 2023 20:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451001;
        bh=c6HhLWvagHIDunId4tPIMin0kXgpjBY4SQHcKYxzgco=;
        h=Date:To:From:Subject:From;
        b=Ka45Gy3mopeJxp3rNxBXIlmX4N4wHLAJ5IjbtTPe3tsH3dOE6vzDqGIHr5XvEaoZs
         LfkN7lgUzh13Kht6ssiED7KVu/ytdgQ5qfeN3bMWgdBUJ/IX7ovU1q/zeM4PV/8r03
         wIbNB0wUQdbruX1YACMbNgPB4H9asvCDR6oXnkNY=
Date:   Wed, 04 Oct 2023 13:23:19 -0700
To:     mm-commits@vger.kernel.org, sourabhjain@linux.ibm.com,
        heiko.carstens@de.ibm.com, hbathini@linux.ibm.com,
        eric.devolder@oracle.com, bhe@redhat.com, costa.shul@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] docs-fix-link-s390-zfcpdumprst.patch removed from -mm tree
Message-Id: <20231004202320.ACBC0C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: docs: fix link s390/zfcpdump.rst
has been removed from the -mm tree.  Its filename was
     docs-fix-link-s390-zfcpdumprst.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Costa Shulyupin <costa.shul@redhat.com>
Subject: docs: fix link s390/zfcpdump.rst
Date: Fri, 25 Aug 2023 04:30:57 +0300

After move of Documentation/s390 to Documentation/arch/s390

Link: https://lkml.kernel.org/r/20230825013102.1487979-1-costa.shul@redhat.com
Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Eric DeVolder <eric.devolder@oracle.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.kexec |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/Kconfig.kexec~docs-fix-link-s390-zfcpdumprst
+++ a/kernel/Kconfig.kexec
@@ -110,7 +110,7 @@ config CRASH_DUMP
 	  For more details see Documentation/admin-guide/kdump/kdump.rst
 
 	  For s390, this option also enables zfcpdump.
-	  See also <file:Documentation/s390/zfcpdump.rst>
+	  See also <file:Documentation/arch/s390/zfcpdump.rst>
 
 config CRASH_HOTPLUG
 	bool "Update the crash elfcorehdr on system configuration changes"
_

Patches currently in -mm which might be from costa.shul@redhat.com are


