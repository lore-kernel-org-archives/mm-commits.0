Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E99EC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 20:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241043AbiC1UXP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 16:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344410AbiC1UWn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 16:22:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9581644A3B
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 13:21:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 329E261476
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 20:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802CFC34100;
        Mon, 28 Mar 2022 20:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648498861;
        bh=e/+4DvTB1JgrwWME1QSx+10qtqzYQ98TJ4Xy6Z8fqXY=;
        h=Date:To:From:Subject:From;
        b=gBQP05imONcXtJ/Y8MYTUq5rJGgZEF2pS4V6Wo2TNC5fpWjUMi+Ymz3E2hVzlcPpl
         QNlD/8UtyG/im2kiQdy+r79ZokpCE2y3vFBOC/hnPFqqdajPWHR/eqw35v17L/r5eR
         H50CX1K3wm0QB0wCNgEbgTqdhyam9ARY3uOeuEsQ=
Date:   Mon, 28 Mar 2022 13:21:00 -0700
To:     mm-commits@vger.kernel.org, kirill.tkhai@openvz.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-kirills-email.patch added to -mm tree
Message-Id: <20220328202101.802CFC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Kirill's email
has been added to the -mm tree.  Its filename is
     mailmap-update-kirills-email.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mailmap-update-kirills-email.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mailmap-update-kirills-email.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kirill Tkhai <kirill.tkhai@openvz.org>
Subject: mailmap: update Kirill's email

My new email address is kirill.tkhai@openvz.org.

Link: https://lkml.kernel.org/r/164846762354.278960.13129571556274098855.stgit@pro
Signed-off-by: Kirill Tkhai <kirill.tkhai@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-kirills-email
+++ a/.mailmap
@@ -212,6 +212,7 @@ Kees Cook <keescook@chromium.org> <kees@
 Keith Busch <kbusch@kernel.org> <keith.busch@intel.com>
 Keith Busch <kbusch@kernel.org> <keith.busch@linux.intel.com>
 Kenneth W Chen <kenneth.w.chen@intel.com>
+Kirill Tkhai <kirill.tkhai@openvz.org> <ktkhai@virtuozzo.com>
 Konstantin Khlebnikov <koct9i@gmail.com> <khlebnikov@yandex-team.ru>
 Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
 Koushik <raghavendra.koushik@neterion.com>
_

Patches currently in -mm which might be from kirill.tkhai@openvz.org are

mailmap-update-kirills-email.patch

