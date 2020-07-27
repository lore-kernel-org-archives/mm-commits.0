Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7013C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 23:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABD7920809
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 23:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595893848;
	bh=2DMoDJFvgvgbBqlHk1fqdvvdg3TeFDzSGTqrDPxd1kI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=NzFBrMJTYT1QNggwvaGyXXCJZmOo6q9aCSoIcmXySES1LIB6Dh/Co0jgQFH+Akju/
	 cC5aMqDYQBpsGLVri6ym4XEfoe7usGX52wabFtsPx+do4C9vcWAPTzFj7OhZLczZXt
	 0mMIWR0dR0O5RjUjANSmm4vhhn27WkTD3Dfer5qQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgG0Xus (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 19:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgG0Xus (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 19:50:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FF8320729;
        Mon, 27 Jul 2020 23:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595893847;
        bh=2DMoDJFvgvgbBqlHk1fqdvvdg3TeFDzSGTqrDPxd1kI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dXBrvTkmL4wmJVgsEHXIxKYBGaY2Y9LgeTzNtKWMYWZrdi8WiAGmkxfv15DBCpxIg
         j2PJMRgIUFV148HiLRKYC5ZtmRFsWG/LjvJc2fPWeF7hu30PPExF4AFrGgqNgSyFKu
         w+LLERw76NxjoS1r3H5QgHOM5jiiADNxLFC2NvXg=
Date:   Mon, 27 Jul 2020 16:50:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     apw@canonical.com, colin.king@canonical.com, corbet@lwn.net,
        dan.j.williams@intel.com, gregkh@linuxfoundation.org,
        joe@perches.com, jslaby@suse.cz, mishi@linux.com,
        mm-commits@vger.kernel.org, sj38.park@gmail.com, sjpark@amazon.de,
        skhan@linuxfoundation.org
Subject:  [obsolete]
 scripts-deprecated_terms-sync-with-inclusive-terms.patch removed from -mm
 tree
Message-ID: <20200727235046.mAChqoGiq%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/deprecated_terms: sync with inclusive terms
has been removed from the -mm tree.  Its filename was
     scripts-deprecated_terms-sync-with-inclusive-terms.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: scripts/deprecated_terms: sync with inclusive terms

# NOTE: this patch is based on next/master, as this is a followup of
# commit 0d8b43e5876a ("scripts/deprecated_terms: recommend
# denylist/allowlist instead of blacklist/whitelist"), which merged in
# next tree only.

Commit a5f526ecb075 ("CodingStyle: Inclusive Terminology") introduced
more terms to be deprecated with more alternatives.  This commit updates
'deprecated_terms.txt' to sync with it.

Link: http://lkml.kernel.org/r/20200713071912.24432-1-sjpark@amazon.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: SeongJae Park <sj38.park@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mishi Choudhary <mishi@linux.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/deprecated_terms.txt |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/scripts/deprecated_terms.txt~scripts-deprecated_terms-sync-with-inclusive-terms
+++ a/scripts/deprecated_terms.txt
@@ -3,5 +3,8 @@
 # The format of each line is:
 # deprecated||suggested
 #
-blacklist||denylist
-whitelist||allowlist
+blacklist||(denylist|blocklist)
+# For other alternatives of 'slave', Please refer to
+# Documentation/process/coding-style.rst
+slave||(secondary|target|...)
+whitelist||(allowlist|passlist)
_

Patches currently in -mm which might be from sjpark@amazon.de are


