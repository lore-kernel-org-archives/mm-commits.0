Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDD6C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 01:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238713AbiBVB4Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 20:56:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238692AbiBVB4P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 20:56:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3130F25C4C
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 17:55:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE869B817F8
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 01:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9D4C340E9;
        Tue, 22 Feb 2022 01:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645494948;
        bh=VclQwl0/7u1ixxWk56vaCiL8HfOPh2Ok0nPWOtdruFI=;
        h=Date:To:From:Subject:From;
        b=uJzoxcdWV1AYFzReaYzDrc7XjW12+Qdr9nHHKDdfeAiOgChqxTi987amZ0f/jGrNJ
         E0dJxk3iTlgiTlpAUwPWLJFqmGyFiFlTx3L2vrVh8Cl+EwrMKq7WBC2JIYCttcdLAX
         KgHGV4oovu/hvFtOhU6G7qcUic2InOIX9raWhp2A=
Date:   Mon, 21 Feb 2022 17:55:48 -0800
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-roman-gushchins-email.patch added to -mm tree
Message-Id: <20220222015548.8A9D4C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Roman Gushchin's email
has been added to the -mm tree.  Its filename is
     mailmap-update-roman-gushchins-email.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mailmap-update-roman-gushchins-email.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mailmap-update-roman-gushchins-email.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mailmap: update Roman Gushchin's email

I'm moving to a @linux.dev account. Map my old addresses.

Link: https://lkml.kernel.org/r/20220221200006.416377-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 +++
 1 file changed, 3 insertions(+)

--- a/.mailmap~mailmap-update-roman-gushchins-email
+++ a/.mailmap
@@ -333,6 +333,9 @@ Rémi Denis-Courmont <rdenis@simphalempi
 Ricardo Ribalda <ribalda@kernel.org> <ricardo@ribalda.com>
 Ricardo Ribalda <ribalda@kernel.org> Ricardo Ribalda Delgado <ribalda@kernel.org>
 Ricardo Ribalda <ribalda@kernel.org> <ricardo.ribalda@gmail.com>
+Roman Gushchin <roman.gushchin@linux.dev> <guro@fb.com>
+Roman Gushchin <roman.gushchin@linux.dev> <guroan@gmail.com>
+Roman Gushchin <roman.gushchin@linux.dev> <klamm@yandex-team.ru>
 Ross Zwisler <zwisler@kernel.org> <ross.zwisler@linux.intel.com>
 Rudolf Marek <R.Marek@sh.cvut.cz>
 Rui Saraiva <rmps@joel.ist.utl.pt>
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

maintainers-add-myself-as-a-memcg-co-maintainer.patch
mailmap-update-roman-gushchins-email.patch

