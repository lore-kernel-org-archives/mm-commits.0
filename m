Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC6FC433ED
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 23:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3B40613FE
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 23:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243885AbhELXdo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 19:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240668AbhELW6D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 May 2021 18:58:03 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113B1C061760
        for <mm-commits@vger.kernel.org>; Wed, 12 May 2021 15:55:30 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FgVW14VGRz9sWP;
        Thu, 13 May 2021 08:55:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1620860127;
        bh=8xj7IpoIJwLhsv5p4VB2F7Iy6w4wowybWtxOpfUs6rM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tkKWT2mTCGwsNgrMa6hfDBaAX+rOOCY9EB9k10jtaSrY/pmCooJSNdX0qeRj9xbke
         Chu5mDxiD6bM9bT/BKPRSohNDWIfKPEAqbCzr7fea3E5eufaVXxXYjSliNx8+v2c9Z
         0zZZJu4ui2jgqVAAz+b3V0GXLst+QQvkdaEjSatwEZFV2lHjk2uaFI8IXub99tYsdA
         CkMXmoO10z+8iphueIJpB0GVHWOI7GeiYx+fxSimimkl2LOZIGi/NrcB1JyHJvFwwe
         J7CtPdoMrkhavtPbTXcRbbROgIZ3SdSt92VAmTC9PCZACrPoWZewGwutnzXtH1secM
         XHVUlIJFOpqKg==
Date:   Thu, 13 May 2021 08:55:24 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     hdanton@sina.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject: Re: [failures]
 mm-vmalloc-switch-to-bulk-allocator-in-__vmalloc_area_node.patch removed
 from -mm tree
Message-ID: <20210513085524.71ae6900@canb.auug.org.au>
In-Reply-To: <20210512202949.eUYaWpNcg%akpm@linux-foundation.org>
References: <20210512202949.eUYaWpNcg%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4IdqdcN=Mpkya=Aad5NmPEp";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/4IdqdcN=Mpkya=Aad5NmPEp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 12 May 2021 13:29:49 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm/vmalloc: switch to bulk allocator in __vmalloc_area_node=
()
> has been removed from the -mm tree.  Its filename was
>      mm-vmalloc-switch-to-bulk-allocator-in-__vmalloc_area_node.patch
>=20
> This patch was dropped because it had testing failures

Removed from linux-next.

--=20
Cheers,
Stephen Rothwell

--Sig_/4IdqdcN=Mpkya=Aad5NmPEp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCcXNwACgkQAVBC80lX
0Gzwrgf/bhLbWeT9uUJ0DkFaVcW/m1tQDFGxk9WasL05OX1FPUEbgCdbZeyP8xoY
qq8MvGTzu9O1JTO2VDb1GtG6iOL06ixt+86Fnfgi2lzPOc6DwkMpLWOZvaHJydLv
J9yzGrLHNhoAWFPdVFztADmITRJLsPlfhXE2MsUJXFiVyuHfdaIJWE+tc6jtiLpe
MWzvg3Fdc8aEgLewGvxn4oAklUTzZMCgE1vOpfggvBXthE5q6Lgr7Loh3XsqT5P6
txaOwJRYiP6tPky2ZapaNNvMnKpv5QCtTnqMAl1nQ7zkEW/CKCg3221EydZobx7b
1pQ2AhBcpT0AUJvjlAqwxWSaD/yIRg==
=W55O
-----END PGP SIGNATURE-----

--Sig_/4IdqdcN=Mpkya=Aad5NmPEp--
