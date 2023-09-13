Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22545EE020F
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 22:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjIMWRl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 18:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjIMWRk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 18:17:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B140198B
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 15:17:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4419C433C8;
        Wed, 13 Sep 2023 22:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694643456;
        bh=IuI3vMhBzfVIOTLJkvInJHh8GvIhm4nIoeRXaUXdlss=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yvnGjWz1bhYLquTpobcBfaaLr7EyK0D9ZayHWmwc48dOw68icW9eIFPd8vO2IihRs
         sqJK8bRfciykORSDPiPkjXG82WmQ6zNmPp/9UiAgiT/1EcunuQy6aw6278hC90Xmho
         YnP6nvNzsny4zIP6de8BIln+YtG30vjZCppovzM4=
Date:   Wed, 13 Sep 2023 15:17:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        gustavoars@kernel.org, dwaipayanray1@gmail.com, apw@canonical.com,
        joe@perches.com
Subject: Re: +
 checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check.patch
 added to mm-nonmm-unstable branch
Message-Id: <20230913151735.2584e7d719f3310291f8cb74@linux-foundation.org>
In-Reply-To: <b3065a3d-bfd5-2391-50aa-76279c3af52e@embeddedor.com>
References: <20230913212211.D51E1C433C9@smtp.kernel.org>
        <b3065a3d-bfd5-2391-50aa-76279c3af52e@embeddedor.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 13 Sep 2023 16:12:52 -0600 "Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> > Link: https://lore.kernel.org/lkml/ZQCaO+tYycDxVLy7@work/
> > Link: https://lkml.kernel.org/r/edb667e19211652a32ef6069159bb85dbc3bcdfc.1694636817.git.joe@perches.com
> > Original-patch-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> This patch should include the following tags:
> 
> Co-developed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

added, thanks.
