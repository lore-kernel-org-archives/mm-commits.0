Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0BEC7619A
	for <mm-commits@archiver.kernel.org>; Wed, 12 Apr 2023 01:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjDLBp1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Apr 2023 21:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjDLBp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Apr 2023 21:45:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A54044B9
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 18:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18B186279F
        for <mm-commits@vger.kernel.org>; Wed, 12 Apr 2023 01:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E31C433EF;
        Wed, 12 Apr 2023 01:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681263925;
        bh=j80YBdYsZNAQfvViDKJ7jgdQUNZ7F9AlpsmkiGspRxU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tYTclY4PbVGf9pZ802IAhUeqUvv0Qfr5hT0bStYP7BNnSGHeTqKgOXOPGB3z9MbHc
         Ta+qRSAfSot+SJr85FLLRVSfoxvloCyKkCKdibzaIfKLhJOaEIrOwEX0t/wFwmVq/n
         X+CddDiCzl+95eC9iQIi/eDa2gVc6bhjwl9bA03w=
Date:   Tue, 11 Apr 2023 18:45:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     mm-commits@vger.kernel.org, sam@ravnborg.org,
        ruben.ayrapetyan@arm.com, pvorel@suse.cz, kevin.brodsky@arm.com
Subject: Re: + uapi-linux-consth-prefer-iso-friendly-__typeof__.patch added
 to mm-nonmm-unstable branch
Message-Id: <20230411184524.e02485cc300433bcf1a7d470@linux-foundation.org>
In-Reply-To: <CAK7LNATXj+xV3Q_qeO_aO-fBhNif7i7sYQAo0oLVW=M1pGmHEA@mail.gmail.com>
References: <20230412002416.ED32CC433EF@smtp.kernel.org>
        <CAK7LNATXj+xV3Q_qeO_aO-fBhNif7i7sYQAo0oLVW=M1pGmHEA@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 12 Apr 2023 10:33:02 +0900 Masahiro Yamada <masahiroy@kernel.org> wrote:

> > Link: https://lkml.kernel.org/r/20230411092747.3759032-1-kevin.brodsky@arm.com
> > Fixes: d6fc9fcbaa65 ("kbuild: compile-test exported headers to ensure they are self-contained")
> 
> 
> This tag is wrong.
> 
> The correct one is:
> 
> Fixes: a85cbe6159ff ("uapi: move constants from <linux/kernel.h> to
> <linux/const.h>")

Fixed, thanks.
