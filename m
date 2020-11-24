Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB8BC56201
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 10:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F0D820708
	for <mm-commits@archiver.kernel.org>; Tue, 24 Nov 2020 10:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=privacyrequired.com header.i=@privacyrequired.com header.b="DQm9j8Ej"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731618AbgKXKWJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Nov 2020 05:22:09 -0500
Received: from devianza.investici.org ([198.167.222.108]:22429 "EHLO
        devianza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732046AbgKXKWJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2020 05:22:09 -0500
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2020 05:22:07 EST
Received: from mx2.investici.org (unknown [127.0.0.1])
        by devianza.investici.org (Postfix) with ESMTP id 4CgKcF229Bz6vQS;
        Tue, 24 Nov 2020 10:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1606212829;
        bh=gUPEztGhslPpv6bFeoHpymci/BNaaG0nIMg6StC1KnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQm9j8EjcCjuzKZQqU5UPeV7+Nf1DgRd/HvFduYTGSXoj5rDqGhEttpyxFaDncIbB
         p0bq8I7BqV9zPBbzKesCMXgp+WJfgDpTGtg6PADeqWgtdwfPz5b/dsK58OFDYVrAHq
         6yuDdN08XfcZNIWU0Y3UxI6L1fdHPSZj+Pljoiig=
Received: from [198.167.222.108] (mx2.investici.org [198.167.222.108]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CgKcD6sjGz6vQ7;
        Tue, 24 Nov 2020 10:13:48 +0000 (UTC)
From:   Francis Laniel <laniel_francis@privacyrequired.com>
To:     akpm@linux-foundation.org
Cc:     danielmicay@gmail.com, dja@axtens.net, keescook@chromium.org,
        mm-commits@vger.kernel.org
Subject: Re: + correct-wrong-filenames-in-comment.patch added to -mm tree
Date:   Tue, 24 Nov 2020 11:13:48 +0100
Message-ID: <6349599.higeI0jBtf@machine>
In-Reply-To: <20201124011927.EkMZzlqAw%akpm@linux-foundation.org>
References: <20201124011927.EkMZzlqAw%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

I am not sure if I should add a mailing list to this mail but thank you for=
=20
the addition of the patches!

Le mardi 24 novembre 2020, 02:19:27 CET akpm@linux-foundation.org a =E9crit=
 :
> The patch titled
>      Subject: drivers/misc/lkdtm/lkdtm.h: correct wrong filenames in comm=
ent
> has been added to the -mm tree.  Its filename is
>      correct-wrong-filenames-in-comment.patch
>=20
> This patch should soon appear at
>   =20
> https://ozlabs.org/~akpm/mmots/broken-out/correct-wrong-filenames-in-comm=
en
> t.patch and later at
>   =20
> https://ozlabs.org/~akpm/mmotm/broken-out/correct-wrong-filenames-in-comm=
en
> t.patch
>=20
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>=20
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng
> your code ***
>=20
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>=20
> ------------------------------------------------------
> From: Francis Laniel <laniel_francis@privacyrequired.com>
> Subject: drivers/misc/lkdtm/lkdtm.h: correct wrong filenames in comment
>=20
> In lkdtm.h, files targeted in comments are named "lkdtm_file.c" while
> there are named "file.c" in directory.
>=20
> Link:
> https://lkml.kernel.org/r/20201122162451.27551-6-laniel_francis@privacyre=
qu
> ired.com Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.co=
m>
> Acked-by: Kees Cook <keescook@chromium.org>
> Cc: Daniel Axtens <dja@axtens.net>
> Cc: Daniel Micay <danielmicay@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  drivers/misc/lkdtm/lkdtm.h |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> --- a/drivers/misc/lkdtm/lkdtm.h~correct-wrong-filenames-in-comment
> +++ a/drivers/misc/lkdtm/lkdtm.h
> @@ -6,7 +6,7 @@
>=20
>  #include <linux/kernel.h>
>=20
> -/* lkdtm_bugs.c */
> +/* bugs.c */
>  void __init lkdtm_bugs_init(int *recur_param);
>  void lkdtm_PANIC(void);
>  void lkdtm_BUG(void);
> @@ -35,7 +35,7 @@ void lkdtm_CORRUPT_PAC(void);
>  void lkdtm_FORTIFY_OBJECT(void);
>  void lkdtm_FORTIFY_SUBOBJECT(void);
>=20
> -/* lkdtm_heap.c */
> +/* heap.c */
>  void __init lkdtm_heap_init(void);
>  void __exit lkdtm_heap_exit(void);
>  void lkdtm_OVERWRITE_ALLOCATION(void);
> @@ -47,7 +47,7 @@ void lkdtm_SLAB_FREE_DOUBLE(void);
>  void lkdtm_SLAB_FREE_CROSS(void);
>  void lkdtm_SLAB_FREE_PAGE(void);
>=20
> -/* lkdtm_perms.c */
> +/* perms.c */
>  void __init lkdtm_perms_init(void);
>  void lkdtm_WRITE_RO(void);
>  void lkdtm_WRITE_RO_AFTER_INIT(void);
> @@ -62,7 +62,7 @@ void lkdtm_EXEC_NULL(void);
>  void lkdtm_ACCESS_USERSPACE(void);
>  void lkdtm_ACCESS_NULL(void);
>=20
> -/* lkdtm_refcount.c */
> +/* refcount.c */
>  void lkdtm_REFCOUNT_INC_OVERFLOW(void);
>  void lkdtm_REFCOUNT_ADD_OVERFLOW(void);
>  void lkdtm_REFCOUNT_INC_NOT_ZERO_OVERFLOW(void);
> @@ -83,10 +83,10 @@ void lkdtm_REFCOUNT_SUB_AND_TEST_SATURAT
>  void lkdtm_REFCOUNT_TIMING(void);
>  void lkdtm_ATOMIC_TIMING(void);
>=20
> -/* lkdtm_rodata.c */
> +/* rodata.c */
>  void lkdtm_rodata_do_nothing(void);
>=20
> -/* lkdtm_usercopy.c */
> +/* usercopy.c */
>  void __init lkdtm_usercopy_init(void);
>  void __exit lkdtm_usercopy_exit(void);
>  void lkdtm_USERCOPY_HEAP_SIZE_TO(void);
> @@ -98,7 +98,7 @@ void lkdtm_USERCOPY_STACK_FRAME_FROM(voi
>  void lkdtm_USERCOPY_STACK_BEYOND(void);
>  void lkdtm_USERCOPY_KERNEL(void);
>=20
> -/* lkdtm_stackleak.c */
> +/* stackleak.c */
>  void lkdtm_STACKLEAK_ERASING(void);
>=20
>  /* cfi.c */
> _
>=20
> Patches currently in -mm which might be from
> laniel_francis@privacyrequired.com are
>=20
> stringh-add-fortify-coverage-for-strscpy.patch
> add-new-file-in-lkdtm-to-test-fortified-strscpy.patch
> correct-wrong-filenames-in-comment.patch




