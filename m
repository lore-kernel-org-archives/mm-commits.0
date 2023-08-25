Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78DBC71134
	for <mm-commits@archiver.kernel.org>; Fri, 25 Aug 2023 18:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjHYSmH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Aug 2023 14:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjHYSlv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Aug 2023 14:41:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B833CD2
        for <mm-commits@vger.kernel.org>; Fri, 25 Aug 2023 11:41:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEA2C62A6E
        for <mm-commits@vger.kernel.org>; Fri, 25 Aug 2023 18:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050E2C433C8;
        Fri, 25 Aug 2023 18:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692988909;
        bh=43DLPB8cKP3k4uNAPlfEAMEPV8hTaAr3l0QqIp+XuGI=;
        h=Date:To:From:Subject:From;
        b=AYQpfmcjF9ekg6/IJG/wkqCxEOF4YBuczsgFj+s5opqVUF1uy3XEpAFfPgzJLEX1W
         Mv49in1009eil174iwEFJael22Jw4BOUXDFkgqfIj8SuP+RPmhvkP8gvcJl59Bx5rI
         2mzBlluPNZSFGXUEmzHkW8eOW7yfUILfh9CwKeFg=
Date:   Fri, 25 Aug 2023 11:41:47 -0700
To:     mm-commits@vger.kernel.org, sourabhjain@linux.ibm.com,
        heiko.carstens@de.ibm.com, hbathini@linux.ibm.com,
        eric.devolder@oracle.com, bhe@redhat.com, costa.shul@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-fix-link-s390-zfcpdumprst.patch added to mm-nonmm-unstable branch
Message-Id: <20230825184149.050E2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: fix link s390/zfcpdump.rst
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     docs-fix-link-s390-zfcpdumprst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-fix-link-s390-zfcpdumprst.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -110,6 +110,6 @@ config CRASH_DUMP
 	  For more details see Documentation/admin-guide/kdump/kdump.rst
 
 	  For s390, this option also enables zfcpdump.
-	  See also <file:Documentation/s390/zfcpdump.rst>
+	  See also <file:Documentation/arch/s390/zfcpdump.rst>
 
 endmenu
_

Patches currently in -mm which might be from costa.shul@redhat.com are

docs-fix-link-s390-zfcpdumprst.patch

