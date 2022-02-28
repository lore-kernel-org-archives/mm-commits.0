Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC56C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 28 Feb 2022 00:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiB1Atd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 27 Feb 2022 19:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbiB1Ata (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 27 Feb 2022 19:49:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397893DA6C
        for <mm-commits@vger.kernel.org>; Sun, 27 Feb 2022 16:48:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE984B80D68
        for <mm-commits@vger.kernel.org>; Mon, 28 Feb 2022 00:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96241C340E9;
        Mon, 28 Feb 2022 00:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646009329;
        bh=8iVEZNNwJFDpWc2ec3Z1PGXiszOD4jWqGlSsPK1dM40=;
        h=Date:To:From:Subject:From;
        b=Ri3xVQ5lgUw53SH6xjd41gcdZivcNCtGlgqHrniDOT+zWQdjZbRjHvWs1LtsRjLZi
         Eg5Yz+aruTt3pRbfdG3/r0LzOVPQIkKxlucP/mm58xxCCgo/WTNY/I1DgdH8dNxJ22
         VYzUAV5bftAjSs3Lf/0Y1XnFJOi4gCB3VhV9imH8=
Date:   Sun, 27 Feb 2022 16:48:49 -0800
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mailmap-update-roman-gushchins-email.patch removed from -mm tree
Message-Id: <20220228004849.96241C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Roman Gushchin's email
has been removed from the -mm tree.  Its filename was
     mailmap-update-roman-gushchins-email.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


