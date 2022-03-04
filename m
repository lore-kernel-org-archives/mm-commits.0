Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8833AC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  4 Mar 2022 03:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbiCDDIl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Mar 2022 22:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiCDDIk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Mar 2022 22:08:40 -0500
X-Greylist: delayed 345 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Mar 2022 19:07:52 PST
Received: from gimli.rothwell.id.au (gimli.rothwell.id.au [103.230.158.156])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7053BFA1
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 19:07:51 -0800 (PST)
Received: from authenticated.rothwell.id.au (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.rothwell.id.au (Postfix) with ESMTPSA id 4K8t1N2ZVnzyR1;
        Fri,  4 Mar 2022 14:02:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rothwell.id.au;
        s=201702; t=1646362922;
        bh=Ccc5BbPkmlIjiVsISkbVNbgv5wsU+422nUENkGQK0Q4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c86pa0X+gEAZLCxfsDj1IASL8fld6Z4IVJZyxUPtv3cxHPlnC2utqWsnicTqxT2vm
         u4nUYielDq0korIJE360z2AFYzeSCwYb3WZUEMOAIytobNPy2NMaPst0chlpwF+vlo
         P3NLkVMvC58+CbrkQ2LoXZLKPA0wO0gUl6h1m75ckc7aMmaN/x1bKB5uIlyftZxAGX
         ufJ+NePQkdPXHKoRXUwmc8fASECn4tyJib98E1xprRYxQ8HOmmHDzlbBPqE5JZcLQG
         tN8UHkU+hjUba2+NMWBwD1bOe017Tex8be1IVvIFo6/ujp5AY2E+0/IFmEhInEfns3
         3+ekRMeC8hg6Q==
Date:   Fri, 4 Mar 2022 14:01:59 +1100
From:   Stephen Rothwell <sfr@rothwell.id.au>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        rppt@linux.vnet.ibm.com, peterx@redhat.com, jack@suse.cz,
        david@redhat.com, aarcange@redhat.com, namit@vmware.com
Subject: Re: + userfaultfd-provide-unmasked-address-on-page-fault-v3.patch
 added to -mm tree
Message-ID: <20220304140159.616f8479@elm.ozlabs.ibm.com>
In-Reply-To: <20220304015356.2F88DC004E1@smtp.kernel.org>
References: <20220304015356.2F88DC004E1@smtp.kernel.org>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/e_qeL7jNxngibhL620uXHWH";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/e_qeL7jNxngibhL620uXHWH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 03 Mar 2022 17:53:55 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> The patch titled
>      Subject: userfaultfd: provide unmasked address on page-fault
> has been added to the -mm tree.  Its filename is
>      userfaultfd-provide-unmasked-address-on-page-fault-v3.patch

Added to linux-next today.
--=20
Cheers,
Stephen Rothwell

--Sig_/e_qeL7jNxngibhL620uXHWH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIhgScACgkQAVBC80lX
0GxL+ggAnfLGTbvihXUTn0SsrsT+NWSk/sqvYz9gcxRCVigx+gdH+UmVcXCtmGKk
q9q8qiKjVjS6xmiWOvXkgHeZnqfwcAVSC3Sf5ofu+DGF8U2l0iuqUCyq2biWLS22
/jwmJEspWgHwMwyXtUjRpLsT49nwrca/Gm+UyI5F6gRlIyw5o7+stADo3g9BaByq
7zlXvv0yFn4F9FJbHcMIufHq87ylLEaTo3nYhTN/tQIQ9sn9I3RmrBHXjLwUbcCk
zrUJVQDkTSOXSCjS0/J1gOyuCf6XD5asnzhqQOVudXTq53REg11T89VgJqmpD4eE
qe/EA9s4CY/Tv2HxI9MmhVd/ULlu2g==
=kqLz
-----END PGP SIGNATURE-----

--Sig_/e_qeL7jNxngibhL620uXHWH--
