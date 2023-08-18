Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86298EE4997
	for <mm-commits@archiver.kernel.org>; Fri, 18 Aug 2023 21:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbjHRVCo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Aug 2023 17:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjHRVCS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Aug 2023 17:02:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BC94214
        for <mm-commits@vger.kernel.org>; Fri, 18 Aug 2023 14:02:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F4B7645F3
        for <mm-commits@vger.kernel.org>; Fri, 18 Aug 2023 21:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9C6C433C7;
        Fri, 18 Aug 2023 21:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692392535;
        bh=rO7ZKX8b0Nq+ahbPZvp3p/5+cR1IN4mb8ahEyaf8qCk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cLpoRM53IY9Q6M3z+wd8aVuqpQb2nRMrDfQDMtIFVit5ydyTXQj6tNgdNWruCAVA3
         8x+EogHSClApN1OIAYcMpzZ0kllnK51ZoAFY8skaCBpzUWb0WzcM+AP9Nd3aN92y0e
         sO2D9PMr9iRWx8z9W6PCk1nL80Y8k79KZBriCj5w=
Date:   Fri, 18 Aug 2023 14:02:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, hughd@google.com,
        david@redhat.com, peterx@redhat.com
Subject: Re: + mm-wire-up-tail-page-poisoning-over-mappings.patch added to
 mm-unstable branch
Message-Id: <20230818140214.33027519d09c55f8f2221479@linux-foundation.org>
In-Reply-To: <ZN/Uvq1qtlmK25e5@casper.infradead.org>
References: <20230818200031.BC269C433C9@smtp.kernel.org>
        <ZN/Uvq1qtlmK25e5@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 18 Aug 2023 21:29:50 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Fri, Aug 18, 2023 at 01:00:30PM -0700, Andrew Morton wrote:
> > From: Peter Xu <peterx@redhat.com>
> > Subject: mm: wire up tail page poisoning over ->mappings
> > Date: Tue, 15 Aug 2023 17:06:59 -0400
> 
> Did I need to keep NAKing this patch, or did you disagree with my NAK?

This is the first time this patch has been sent out (under this title)
and it sat on the lists unreplied-to for three days.

