Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08499C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 19:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357909AbiELTUN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 15:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiELTUL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 15:20:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B76025C2B7
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 12:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 994A361C2F
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 19:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DDAC385B8;
        Thu, 12 May 2022 19:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652383210;
        bh=W4QosRQG27hdcT7wK5gRfUIDmOj5FOcOBGdMuIN7ChQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RvGkn3e3QkMBTHw8ATnOcs55EQc9mgfJjZcm2tvBQ+2had7ae6lpiWOV5DUVPbTWm
         ISSaClaqVyso9hTBf9Lz5QkrrQq2RbF8cDkN3VAlInBVu3Pl9/7VW6JVEOqGCdBqU9
         /5nfXKsTG6qc6YlEtcC/koDG/ZIamO2CmdowlRUo=
Date:   Thu, 12 May 2022 12:20:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     mm-commits@vger.kernel.org, yzaikin@google.com,
        viro@zeniv.linux.org.uk, mingo@elte.hu, keescook@chromium.org,
        jpitti@cisco.com
Subject: Re: [obsolete] proc-sysctl-make-protected_-world-readable.patch
 removed from -mm tree
Message-Id: <20220512122009.fad771d1341ef442e62adb28@linux-foundation.org>
In-Reply-To: <Yn1Y60Hbls4tahpX@bombadil.infradead.org>
References: <20220425214652.9F507C385A9@smtp.kernel.org>
        <Yn1Y60Hbls4tahpX@bombadil.infradead.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 12 May 2022 11:58:51 -0700 Luis Chamberlain <mcgrof@kernel.org> wrote:

> I've reivewed this now and you can add:
> 
> Acked-by: Luis Chamberlain <mcgrof@kernel.org>

OK, thanks, I brought it back.

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-sysctl-make-protected_-world-readable.patch
