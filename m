Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D34ECC433FE
	for <mm-commits@archiver.kernel.org>; Sat, 26 Feb 2022 03:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiBZDMB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Feb 2022 22:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiBZDMB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Feb 2022 22:12:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C842671DF
        for <mm-commits@vger.kernel.org>; Fri, 25 Feb 2022 19:11:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 17091CE2834
        for <mm-commits@vger.kernel.org>; Sat, 26 Feb 2022 03:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344C9C340EF;
        Sat, 26 Feb 2022 03:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645845084;
        bh=s6iAYLcuzM2MgwUihUzs7tOHjdYXM3CRLZ/K6F63AdE=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=2JGJC24L5NlTvYKKGHS5nxiKFj4ojfQdLSjvz/iUggqrhQFwpYZJGzKbVo42SMGoo
         t1PfInZvq9bv+qD15LQvnL38uG4ckA13alruxtJrAWNou5FPMI2wqTZy88EJDcqR+A
         b4IRmXonPDG59sJMO5+LzB3DHHdhjeX4ASfpJjBU=
Date:   Fri, 25 Feb 2022 19:11:23 -0800
To:     roman.gushchin@linux.dev, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
Subject: [patch 11/12] mailmap: update Roman Gushchin's email
Message-Id: <20220226031124.344C9C340EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
