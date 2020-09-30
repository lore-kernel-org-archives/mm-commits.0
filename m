Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19CFC4363D
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 23:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DF1820EDD
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 23:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601509833;
	bh=YjDwiek6s586w+PgakgdCECt6f74sItaGwKoN/jD7XU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=XaejWbzvtgFatH1UJH6mC74KqMunXZ1a+HeYsOweSw3gPbxmAJdGolOfvmv3FPL7k
	 P/5Z53R+q0bJHLFvO9KXkDWACp3CP2qcKIV4GaoWiNh8LiT/MX0rKOOBnpfv5A/dxL
	 QlIlZlllXGseESeWhpRL0r0dr1pBGHIsRRsMzg00=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbgI3Xud (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 19:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730326AbgI3Xuc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 19:50:32 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB3EC20B1F;
        Wed, 30 Sep 2020 23:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601509831;
        bh=YjDwiek6s586w+PgakgdCECt6f74sItaGwKoN/jD7XU=;
        h=Date:From:To:Subject:From;
        b=tVfoeunTyw9bDIKlzS8o08ywFUGg9amDJgyv/7O2TJhFr3EmWf1DxgfzyKjsZkjWY
         o/dNwNAPD8Xj4nPDYuLlWhT6ch7spFfSonMFxjvUkSgyXIO9VDaGtA/n1/v5cWdAx4
         JIGhRcq9gMxJi78oIt4jauuzLVHXNeNTqun7ozBQ=
Date:   Wed, 30 Sep 2020 16:50:30 -0700
From:   akpm@linux-foundation.org
To:     ebiggers@google.com, mm-commits@vger.kernel.org
Subject:  + scripts-spellingtxt-fix-malformed-entry.patch added to
 -mm tree
Message-ID: <20200930235030.PE_dxoHHg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: fix malformed entry
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-fix-malformed-entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-fix-malformed-entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-fix-malformed-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: scripts/spelling.txt: fix malformed entry

One of the entries has three fields "mistake||correction||correction"
rather than the expected two fields "mistake||correction".  Fix it.

Link: https://lkml.kernel.org/r/20200930234359.255295-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/spelling.txt~scripts-spellingtxt-fix-malformed-entry
+++ a/scripts/spelling.txt
@@ -590,7 +590,7 @@ explictly||explicitly
 expresion||expression
 exprimental||experimental
 extened||extended
-exteneded||extended||extended
+exteneded||extended
 extensability||extensibility
 extention||extension
 extenstion||extension
_

Patches currently in -mm which might be from ebiggers@google.com are

scripts-spellingtxt-fix-malformed-entry.patch

